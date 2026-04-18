vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
}, { confirm = false })

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
  'tmux',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

-- Defer parser installation and treesitter start until a matching filetype is opened
local installed = false
vim.api.nvim_create_autocmd('FileType', {
  pattern = filetypes,
  callback = function(ev)
    if not installed then
      installed = true
      require('nvim-treesitter').install(filetypes, function()
        -- Start highlighting on the buffer that triggered the install
        pcall(vim.treesitter.start, ev.buf)
      end)
    else
      pcall(vim.treesitter.start, ev.buf)
    end
  end,
})
