-- The tinymist preview is a web page: Neovim has no HTML engine, and `:terminal`
-- cannot display images (neovim#32189), so the page cannot be drawn in a buffer
-- or a split. The closest equivalent is a Chromium "app" window: no tabs, no
-- URL bar, one page, sized like a vertical pane next to the editor. Snap it once
-- (KWin: Meta+Right) and the layout sticks.
--
-- `typst-preview` stops/starts the tinymist server; Chromium is only the screen.
-- The page does not reconnect on its own, so the window is killed before every
-- start and whenever the preview stops, instead of lingering on a dead page.
local PREVIEW_PORT = 41923 -- stable URL, so the pane keeps one address

-- Bracketed first letter: `pkill -f` must not match the shell command running it.
local KILL_WINDOW = 'pkill -f "[t]ypst-preview-browser" >/dev/null 2>&1'

-- One `%s`: typst-preview formats the preview URL into it. Chromium's stderr is
-- dropped because it always complains about VA-API/Vulkan on Wayland and
-- typst-preview would surface that as "opening link failed" on every toggle.
local OPEN_CMD = 'chromium --user-data-dir=/tmp/typst-preview-browser --app=%s --window-size=960,1040 --class=TypstPreview 2>/dev/null'

require('typst-preview').setup {
  backend = 'tinymist',
  port = PREVIEW_PORT,
  open_cmd = OPEN_CMD,
  follow_cursor = true, -- the page scrolls to the line being edited
  dependencies_bin = {
    tinymist = vim.fn.exepath 'tinymist',
    websocat = nil,
  },
}

-- Follow-cursor fixes. The plugin sends Neovim's cursor column as-is, and only
-- when the line changes. Measured against tinymist 0.15:
--   * `character` is a character index (not a byte index) and names a position
--     between characters: tinymist looks at the character before it. Neovim's
--     normal-mode cursor sits on a character, so column 0 (or the first
--     character of a text run, or any column inside a heading's `= ` marker)
--     resolves to nothing and the page does not move.
--   * The plugin skips a request while the line is unchanged, so moving off such
--     a column within the same line never retries.
-- `sync_with_cursor` is replaced so every caller (plugin autocmd, `:TypstPreviewSyncCursor`,
-- the startup nudges below) sends a resolvable position, and the autocmd further
-- down also fires on column changes and in insert mode.
local servers = require 'typst-preview.servers'
local preview_utils = require 'typst-preview.utils'

local last_sent = setmetatable({}, { __mode = 'k' }) -- server -> { key, at }

local function scroll_character()
  local text = vim.api.nvim_get_current_line()
  local char = vim.fn.charidx(text, vim.api.nvim_win_get_cursor(0)[2])
  if char < 0 then
    char = vim.fn.strchars(text)
  end
  local mode = vim.api.nvim_get_mode().mode:sub(1, 1)
  if mode ~= 'i' and mode ~= 'R' then
    char = char + 1 -- on a character -> the position after it
  end
  local marker = text:match '^%s*=+%s+' -- heading marker: no output for it
  if marker then
    char = math.max(char, vim.fn.strchars(marker) + 1)
  end
  return math.min(char, vim.fn.strchars(text))
end

---@diagnostic disable-next-line: duplicate-set-field
servers.sync_with_cursor = function(server)
  if server.suppress then
    return
  end
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local character = scroll_character()
  -- The plugin's own CursorMoved autocmd sends the same position on a line
  -- change; skip the duplicate.
  local key = line .. ':' .. character
  local now = vim.uv.hrtime()
  local prev = last_sent[server]
  if prev and prev.key == key and now - prev.at < 50e6 then
    return
  end
  last_sent[server] = { key = key, at = now }
  local filepath = preview_utils.get_buf_path(0)
  local function scroll_to(l, c)
    server.write(vim.json.encode {
      event = 'panelScrollTo',
      filepath = filepath,
      line = l,
      character = c,
    } .. '\n')
  end

  -- Code lines (`#lorem(25)`, `title: "..."`) have no position in the page, so
  -- tinymist ignores them. When the cursor is not on literal text, scroll first to
  -- the closest text before it (e.g. the end of `*Key idea.*` for the cursor on
  -- the `#lorem(25)` that follows), or to the heading above when nothing closer
  -- exists. The cursor position follows right after and, when the page can
  -- resolve it, replaces that as the final target.
  local heading = vim.fn.search([[^=\+\s]], 'bnWc') -- nearest heading at or above
  local heading0 = heading > 0 and heading - 1 or nil
  local ok, result = pcall(require('typst_scan').analyze, 0, heading0, line, character)
  if ok and result.in_text then
    scroll_to(line, character)
    return
  end
  if ok and result.fallback then
    scroll_to(result.fallback.line, result.fallback.character)
  elseif heading0 and heading0 ~= line then
    local text = vim.api.nvim_buf_get_lines(0, heading0, heading0 + 1, false)[1]
    local marker = text:match '^=+%s+'
    scroll_to(heading0, math.min(vim.fn.strchars(marker) + 1, vim.fn.strchars(text)))
  end
  scroll_to(line, character)
end

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  group = vim.api.nvim_create_augroup('TypstPreviewFollow', { clear = true }),
  callback = function()
    if vim.bo.filetype ~= 'typst' or not require('typst-preview').get_follow_cursor() then
      return
    end
    for _, server in pairs(servers.get_all()) do
      servers.sync_with_cursor(server)
    end
  end,
})

-- One-shot "open in the default browser" for the next link the plugin opens.
-- `open_cmd` is read inside `utils.visit` at the moment the server is up (after an
-- async start), so the override is scoped to that call and the Chromium app window
-- configured in `open_cmd` stays the default for `<leader>tv`.
local browser_once = false
local browser_token = 0
local original_visit = preview_utils.visit
---@diagnostic disable-next-line: duplicate-set-field
preview_utils.visit = function(link)
  if not browser_once then
    return original_visit(link)
  end
  browser_once = false
  local opts = require('typst-preview.config').opts
  local saved = opts.open_cmd
  opts.open_cmd = nil -- plugin default: xdg-open / open / explorer.exe
  local ok, err = pcall(original_visit, link)
  opts.open_cmd = saved
  if not ok then
    error(err)
  end
end

local function preview_running()
  local ok, servers = pcall(require, 'typst-preview.servers')
  if not ok then
    return true -- unknown API: never kill a window that may still be in use
  end
  local path = vim.api.nvim_buf_get_name(0)
  if path == '' then
    return false
  end
  local ok_get, server = pcall(servers.get, path)
  return not ok_get or server ~= nil
end

-- Fresh start: the page opens at its top and only scrolls on the next
-- CursorMoved, so nudge it to the cursor for the first couple of seconds
-- (the browser needs a moment to connect; a lost early nudge is retried).
local function nudge_to_cursor(buf)
  local preview = require 'typst-preview'
  preview.set_follow_cursor(true)
  for _, delay in ipairs { 600, 1400, 2400, 3600 } do
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(buf) or vim.api.nvim_get_current_buf() ~= buf then
        return
      end
      if preview_running() then
        pcall(preview.sync_with_cursor)
      end
    end, delay)
  end
end

local function toggle_preview()
  local buf = vim.api.nvim_get_current_buf()
  local running = preview_running()
  if not running then
    if vim.fn.executable 'chromium' == 0 then
      vim.notify('Typst preview: `chromium` not found, the pane cannot open', vim.log.levels.WARN)
    end
    -- Run apart from `open_cmd` on purpose: as part of the launch command line,
    -- `pkill -f "[t]ypst-preview-browser"` also matches the jobstart shell itself
    -- (that command line contains `--user-data-dir=/tmp/typst-preview-browser`),
    -- so it would SIGTERM the shell right before Chromium is started.
    vim.fn.system(KILL_WINDOW)
  end
  vim.cmd 'TypstPreviewToggle'
  if running then
    vim.fn.jobstart(KILL_WINDOW)
    return
  end

  nudge_to_cursor(buf)
end

-- Start the preview in the default browser (a normal tab) instead of the Chromium
-- app window. If a preview is already running, open one more page for it; stop it
-- with `<leader>tv` as usual. A browser tab cannot be closed from here, and it
-- shows a dead page after the preview stops.
local function open_in_browser()
  local buf = vim.api.nvim_get_current_buf()
  local running = preview_running()
  if not running then
    vim.fn.system(KILL_WINDOW) -- no stale app window from a previous preview
  end
  browser_once = true
  browser_token = browser_token + 1
  local token = browser_token
  vim.defer_fn(function()
    -- Server never came up: do not hijack the next, unrelated launch.
    if browser_token == token then
      browser_once = false
    end
  end, 20000)
  vim.cmd 'TypstPreview'
  if not running then
    nudge_to_cursor(buf)
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typst',
  callback = function(ev)
    vim.keymap.set('n', '<leader>tv', toggle_preview, { buffer = ev.buf, desc = 'Toggle Typst Preview' })
    vim.keymap.set('n', '<leader>tb', open_in_browser, { buffer = ev.buf, desc = 'Typst: preview in default browser' })
    vim.keymap.set('n', '<leader>tf', '<cmd>TypstPreviewFollowCursorToggle<CR>', {
      buffer = ev.buf,
      desc = 'Typst: toggle preview follow cursor',
    })
    vim.keymap.set('n', '<leader>tF', '<cmd>TypstPreviewSyncCursor<CR>', {
      buffer = ev.buf,
      desc = 'Typst: scroll preview to cursor now',
    })
  end,
})
