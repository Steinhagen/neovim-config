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

  -- Fresh start: the page opens at its top and only scrolls on the next
  -- CursorMoved, so nudge it to the cursor for the first couple of seconds
  -- (the browser needs a moment to connect; a lost early nudge is retried).
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

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typst',
  callback = function(ev)
    vim.keymap.set('n', '<leader>tv', toggle_preview, { buffer = ev.buf, desc = 'Toggle Typst Preview' })
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
