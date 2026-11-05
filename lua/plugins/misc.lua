-- Standalone plugins with less than 10 lines of config (sources live in core/pack.lua)
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
