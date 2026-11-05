local filetypes = {
  'bash',
  'c',
  'cmake',
  'cpp',
  'css',
  'dockerfile',
  'gitignore',
  'go',
  'graphql',
  'groovy',
  'html',
  'java',
  'javascript',
  'json',
  'lua',
  'make',
  'markdown',
  'markdown_inline',
  'nix',
  'po',
  'puppet',
  'python',
  'regex',
  'ruby',
  'rust',
  'sql',
  'terraform',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

-- Parser installation is per-filetype: opening a buffer only fetches/compiles the
-- grammar it needs. Installing the whole `filetypes` list up front used to kick
-- off ~33 downloads + compiles the first time any matching buffer was opened.
local function parser_available(ft)
  return #vim.api.nvim_get_runtime_file('parser/' .. ft .. '.so', false) > 0
end

-- Highlighting can only start once the parser exists, so after an install retry
-- briefly (the install itself is async) to highlight the triggering buffer
-- without needing to reopen it.
local function start_when_ready(buf, ft, tries)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end
  if parser_available(ft) then
    pcall(vim.treesitter.start, buf)
  elseif (tries or 0) < 120 then
    vim.defer_fn(function()
      start_when_ready(buf, ft, (tries or 0) + 1)
    end, 500)
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = filetypes,
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft ~= '' and not parser_available(ft) then
      -- `force` because install() trusts parser-info/<lang>.revision and would
      -- skip a parser whose compiled `.so` is gone. We only get here when the
      -- parser is actually missing, so forcing is safe and repairs it.
      require('nvim-treesitter').install({ ft }, { force = true })
    end
    start_when_ready(ev.buf, ft)
  end,
})
