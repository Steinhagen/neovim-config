return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },

  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = {
      [[                                                    ]],
      [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
      [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
      [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
      [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
      [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
      [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
      [[                                                    ]],
    }
    dashboard.section.buttons.val = {
      dashboard.button('e', '  New file', '<cmd>ene<CR>'),
      dashboard.button('f', '  Find file', '<cmd>lua Snacks.picker.files()<CR>'),
      dashboard.button('d', '󰥨  Browse directories', '<cmd>lua Snacks.explorer({ cwd = vim.loop.cwd() })<CR>'),
      dashboard.button('r', '  Recently used files', '<cmd>lua Snacks.picker.recent()<CR>'),
      dashboard.button('t', '󰺮  Find text', '<cmd>lua Snacks.picker.grep({ live = true })<CR>'),
      dashboard.button('sr', '󰁯  Restore session', '<cmd>AutoSession restore<CR>'),
      dashboard.button('sl', '  List sessions', '<cmd>AutoSession search<CR>'),
      dashboard.button('u', '  Update plugins', '<cmd>Lazy update<CR>'),
      dashboard.button('q', '󰈆  Quit', '<cmd>qa<CR>'),
    }

    alpha.setup(dashboard.opts)
  end,
}
