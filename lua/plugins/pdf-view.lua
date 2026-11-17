-- In-editor Typst preview: pdf-view.nvim draws the compiled PDF inside a normal
-- buffer (Kitty graphics protocol; Ghostty/kitty support its placeholders).
-- typst-preview.nvim stays as the browser preview with cursor sync — that part
-- cannot happen in a buffer, so the two complement each other.
--
-- The split follows the writing: while a `*.typ` file has a viewer on screen,
-- edits recompile the PDF (debounced) and the viewer reloads on the same page.
-- Requires `mutool` from MuPDF (nixpkgs: `mupdf`).
require('pdf-view').setup {
  auto_open = true, -- `:edit doc.pdf` opens the viewer
  live_reload = true, -- re-render after `typst compile` rewrites the PDF
  winbar = true, -- "<file> <page> / <pages>" in the viewer window
}

local function pdf_path(buf)
  local src = vim.api.nvim_buf_get_name(buf)
  if src == '' then
    return nil
  end
  return vim.fn.fnamemodify(src, ':r') .. '.pdf'
end

local function pdf_window(path)
  local abs = vim.fn.fnamemodify(path, ':p')
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    -- Split viewers are named `pdf-view://2//<file>`; both end in the file path.
    if name == abs or name:sub(-#abs) == abs then
      return win
    end
  end
  return nil
end

-- A typst.toml marks the project root; `--root` keeps imports outside the
-- document's own directory (template libraries, sibling folders) working.
local function project_root(src)
  local dir = vim.fs.dirname(src)
  local marker = vim.fs.find('typst.toml', { path = dir, upward = true })[1]
  return marker and vim.fs.dirname(marker) or dir
end

local function typst_cmd(buf, out)
  local src = vim.api.nvim_buf_get_name(buf)
  if src == '' or out == nil then
    return nil
  end
  return { 'typst', 'compile', '--root', project_root(src), src, out }
end

-- Synchronous compile: the PDF must be on disk before `:vsplit` opens it.
local function compile(buf, out)
  local cmd = typst_cmd(buf, out)
  if cmd == nil then
    return false
  end
  local res = vim.system(cmd, { text = true }):wait()
  if res.code ~= 0 then
    vim.notify('typst compile failed\n' .. (res.stderr or ''), vim.log.levels.ERROR)
    return false
  end
  return true
end

-- Asynchronous compile for the typing path, so the editor never blocks on
-- `typst`. One process per buffer at a time; edits that land mid-compile mark
-- the buffer for another pass instead of starting a second writer on the same
-- PDF. Failures stay silent there: a half-typed `$` or `#let` is not worth a
-- notification, the next successful compile just replaces the page.
local in_flight, again, seq = {}, {}, {}

local function compile_async(buf)
  local out = pdf_path(buf)
  local cmd = typst_cmd(buf, out)
  if cmd == nil then
    return
  end
  in_flight[buf] = true
  vim.system(cmd, { text = true }, function()
    vim.schedule(function()
      in_flight[buf] = nil
      if again[buf] then
        again[buf] = nil
        if vim.api.nvim_buf_is_valid(buf) then
          compile_async(buf)
        end
      end
    end)
  end)
end

local function schedule_compile(buf, delay)
  seq[buf] = (seq[buf] or 0) + 1
  local generation = seq[buf]
  vim.defer_fn(function()
    if seq[buf] ~= generation or not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    local out = pdf_path(buf)
    if out == nil or pdf_window(out) == nil then
      return -- no viewer open: saves and edits stay as cheap as before
    end
    if in_flight[buf] then
      again[buf] = true
      return
    end
    compile_async(buf)
  end, delay)
end

vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'TextChangedP' }, {
  pattern = '*.typ',
  callback = function(ev)
    schedule_compile(ev.buf, 400)
  end,
})

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.typ',
  callback = function(ev)
    schedule_compile(ev.buf, 0)
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typst',
  callback = function(ev)
    vim.keymap.set('n', '<leader>tV', function()
      if vim.fn.executable 'mutool' == 0 then
        vim.notify('pdf-view.nvim needs `mutool` (nixpkgs: mupdf)', vim.log.levels.WARN)
        return
      end
      local out = pdf_path(ev.buf)
      if out == nil then
        return
      end
      local win = pdf_window(out)
      if win ~= nil then
        vim.api.nvim_win_close(win, true)
        return
      end
      if compile(ev.buf, out) then
        local source_win = vim.api.nvim_get_current_win()
        vim.cmd('vsplit ' .. vim.fn.fnameescape(out))
        -- Keep typing in the source; the split is a viewer, not an editor.
        vim.api.nvim_set_current_win(source_win)
      end
    end, { buffer = ev.buf, desc = 'Typst: PDF preview in a split' })
  end,
})
