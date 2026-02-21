vim.pack.add({
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/igorlfs/nvim-dap-view',
}, { confirm = false })

require 'dap'
require('dap-view').setup {}
