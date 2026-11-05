-- Defer DAP setup until actually needed via user command
vim.api.nvim_create_user_command('DapViewOpen', function()
  require('dap')
  require('dap-view').setup {}
  require('dap-view').open()
end, {})
