vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter"
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

require('nvim-treesitter').install(filetypes)

vim.api.nvim_create_autocmd('FileType', {
  pattern = filetypes,
  callback = function()
    vim.treesitter.start()
  end,
})
