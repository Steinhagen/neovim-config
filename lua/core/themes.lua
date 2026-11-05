-- Theme definitions, shared by core/pack.lua (which installs the active theme
-- plugin) and plugins/colortheme.lua (which applies it).
return {
  catppuccin = {
    src = 'https://github.com/catppuccin/nvim',
    -- The name used for the :colorscheme command
    colorscheme = 'catppuccin',
    -- Function that returns the setup options table
    opts = function(transparent)
      return {
        flavour = 'auto',
        background = { light = 'latte', dark = 'mocha' },
        transparent_background = transparent,
        styles = {
          comments = { 'italic' },
          conditionals = { 'italic' },
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
        },
      }
    end,
  },
  tokyonight = {
    src = 'https://github.com/folke/tokyonight.nvim',
    colorscheme = 'tokyonight',
    opts = function(transparent)
      return {
        style = 'night',
        light_style = 'day',
        transparent = transparent,
        terminal_colors = true,
        styles = {
          keywords = { italic = true },
          sidebars = transparent and 'transparent' or 'dark',
          floats = transparent and 'transparent' or 'dark',
        },
      }
    end,
  },
}
