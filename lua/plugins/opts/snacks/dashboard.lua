return {
  enabled = true,
  preset = {

    header = [[
                                                  
 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ 
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ 
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ 
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ 
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ 
                                                  
      ]],

    keys = {
      { icon = ' ', key = 'e', desc = 'New file', action = ':ene | startinsert' },
      { icon = ' ', key = 'f', desc = 'Find file', action = ':lua Snacks.picker.files()' },
      { icon = '󰥨 ', key = 'd', desc = 'Browse directories', action = ':lua Snacks.explorer({ cwd = vim.loop.cwd() })' },
      { icon = ' ', key = 'r', desc = 'Recently used files', action = ':lua Snacks.picker.recent()' },
      { icon = '󰺮 ', key = 't', desc = 'Find text', action = ':lua Snacks.picker.grep({ live = true })' },
      { icon = '󰁯 ', key = 'sr', desc = 'Restore session', action = ':AutoSession restore' },
      { icon = ' ', key = 'sl', desc = 'List sessions', action = ':AutoSession search' },
      { icon = '󱑢 ', key = 'ul', desc = 'Update lazy plugins', action = ':Lazy update' },
      { icon = '󱑤 ', key = 'up', desc = 'Update pack plugins', action = ':lua vim.pack.update()' },
      { icon = '󰈆 ', key = 'q', desc = 'Quit', action = ':qa' },
    },
  },
}
