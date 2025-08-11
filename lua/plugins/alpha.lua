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
      dashboard.button('e', '  New file', ':ene <CR>'),
      dashboard.button('f', '  Find file', ':Telescope find_files <CR>'),
      dashboard.button('d', '󰥨  Browse directories', ':Telescope file_browser path=. cwd=.<CR>'),
      dashboard.button('r', '  Recently used files', ':Telescope oldfiles <CR>'),
      dashboard.button('t', '󰺮  Find text', ':Telescope live_grep <CR>'),
      dashboard.button('sr', '󰁯  Restore session', ':SessionRestore<CR>'),
      dashboard.button('sl', '  List sessions', '<cmd>lua require("auto-session.session-lens").search_session()<cr>'),
      dashboard.button('u', '  Update plugins', '<cmd>Lazy update<CR>'),
      dashboard.button('q', '󰈆  Quit', ':qa<CR>'),
    }

    alpha.setup(dashboard.opts)
  end,
}
