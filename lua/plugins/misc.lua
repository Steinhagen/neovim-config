-- Standalone plugins with less than 10 lines of config go here
vim.pack.add({
  'https://github.com/tpope/vim-sleuth',        -- Detect tabstop and shiftwidth automatically
  'https://github.com/folke/which-key.nvim',     -- Hints keybinds
  'https://github.com/windwp/nvim-autopairs',    -- Autoclose parentheses, brackets, quotes, etc.
  'https://github.com/folke/todo-comments.nvim', -- Highlight todo, notes, etc in comments
  'https://github.com/catgoose/nvim-colorizer.lua', -- High-performance color highlighter
}, { confirm = false })

vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    require('which-key').setup()
  end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
  once = true,
  callback = function()
    require('nvim-autopairs').setup()
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  once = true,
  callback = function()
    require('todo-comments').setup { signs = false }
    require('colorizer').setup()
  end,
})
