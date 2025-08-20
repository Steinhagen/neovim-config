return {
  'folke/tokyonight.nvim',
  lazy = false, -- make sure we load this during startup
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- Initial states
    local bg_transparent = true
    local is_dark_theme = true

    -- Function to setup tokyonight with current settings
    local setup_tokyonight = function(transparent)
      require('tokyonight').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = 'night', -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        light_style = 'day', -- The theme is used when the background is set to light
        transparent = transparent, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          keywords = { italic = true },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = 'transparent', -- style for sidebars, see below
          floats = 'transparent', -- style for floating windows
        },
        sidebars = { 'qf', 'help', 'neo-tree', 'terminal', 'packer' }, -- Set a darker background on sidebar-like windows
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines
        dim_inactive = false, -- dims inactive windows
        lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

        -- You can override specific color groups to use other groups or a hex color
        -- function will be called with a ColorScheme table
        -- on_colors = function(colors)
        --   -- colors.bg = "#1a1b26"
        --   -- colors.bg_dark = "#16161e"
        -- end,

        --- You can override specific highlights to use other groups or a hex color
        --- function will be called with a Highlights and ColorScheme table
        -- on_highlights = function(highlights, colors)
        --   -- Add a subtle border to the telescope picker
        --   highlights.TelescopeBorder = {
        --     fg = colors.border_highlight,
        --   }
        --   -- Make neo-tree background slightly different
        --   highlights.NeoTreeNormal = {
        --     bg = colors.bg_dark,
        --   }
        --   highlights.NeoTreeNormalNC = {
        --     bg = colors.bg_dark,
        --   }
        -- end,
      }
    end

    -- Toggle background transparency
    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      -- Reconfigure tokyonight with current settings
      setup_tokyonight(bg_transparent)
      -- Reload the colorscheme to apply changes
      vim.cmd [[colorscheme tokyonight]]
    end

    -- Toggle between dark and light themes
    local toggle_theme = function()
      is_dark_theme = not is_dark_theme
      -- Set vim background to match the theme
      vim.o.background = is_dark_theme and 'dark' or 'light'
      -- Reconfigure tokyonight with current settings
      setup_tokyonight(bg_transparent)
      -- Reload the colorscheme to apply changes
      vim.cmd [[colorscheme tokyonight]]
    end

    -- Initial setup
    setup_tokyonight(bg_transparent)
    vim.o.background = is_dark_theme and 'dark' or 'light'
    vim.cmd [[colorscheme tokyonight]]

    -- Set up the keymaps
    vim.keymap.set('n', '<leader>bgt', toggle_transparency, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>bgs', toggle_theme, { noremap = true, silent = true })
  end,
}
