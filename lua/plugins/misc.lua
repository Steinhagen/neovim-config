-- Standalone plugins with less than 10 lines of config go here

-- Detect tabstop and shiftwidth automatically
vim.pack.add({
  'https://github.com/tpope/vim-sleuth',
}, { confirm = false })

-- Hints keybinds
vim.pack.add({
  'https://github.com/folke/which-key.nvim',
}, { confirm = false })

vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    require('which-key').setup()
  end,
})

-- Autoclose parentheses, brackets, quotes, etc.
vim.pack.add({
  'https://github.com/windwp/nvim-autopairs',
}, { confirm = false })

vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    require('nvim-autopairs').setup()
  end,
})

-- Highlight todo, notes, etc in comments (depends on plenary)
vim.pack.add({
  'https://github.com/folke/todo-comments.nvim',
}, { confirm = false })

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    require('todo-comments').setup { signs = false }
  end,
})

-- High-performance color highlighter
vim.pack.add({
  'https://github.com/catgoose/nvim-colorizer.lua',
}, { confirm = false })

require('colorizer').setup()
