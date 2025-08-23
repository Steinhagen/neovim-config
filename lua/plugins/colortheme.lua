return {
  'catppuccin/nvim',
  as = 'catppuccin',
  lazy = false, -- make sure we load this during startup
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    local utils = require 'utils.theme'

    -- Initial states
    local bg_transparent = true

    -- Function to setup tokyonight with current settings
    -- local setup_tokyonight = function(transparent)
    --   require('tokyonight').setup {
    --     -- your configuration comes here
    --     -- or leave it empty to use the default settings
    --     style = 'night', -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
    --     light_style = 'day', -- The theme is used when the background is set to light
    --     transparent = transparent, -- Enable this to disable setting the background color
    --     terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
    --     styles = {
    --       -- Style to be applied to different syntax groups
    --       keywords = { italic = true },
    --       functions = {},
    --       variables = {},
    --       -- Background styles. Can be "dark", "transparent" or "normal"
    --       sidebars = 'transparent', -- style for sidebars, see below
    --       floats = 'transparent', -- style for floating windows
    --     },
    --     sidebars = { 'qf', 'help', 'neo-tree', 'terminal', 'packer' }, -- Set a darker background on sidebar-like windows
    --     day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style
    --     hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines
    --     dim_inactive = false, -- dims inactive windows
    --     lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
    --   }
    -- end

    -- Function to setup catppuccin with current settings
    local setup_catppuccin = function(transparent)
      require('catppuccin').setup {
        flavour = 'auto', -- latte, frappe, macchiato, mocha
        background = { -- :h background
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = transparent, -- disables setting the background color.
        float = {
          transparent = false, -- enable transparent floating windows
          solid = false, -- use solid styling for floating windows, see |winborder|
        },
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = 'dark',
          percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { 'italic' }, -- Change the style of comments
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        auto_integrations = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
      }
    end

    -- Auto-detect system theme on startup
    local is_dark_theme = utils.detect_system_theme()

    -- Toggle background transparency
    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      -- Reconfigure tokyonight with current settings
      setup_catppuccin(bg_transparent)
      -- Reload the colorscheme to apply changes
      vim.cmd [[colorscheme catppuccin]]
    end

    -- Toggle between dark and light themes (manual override)
    local toggle_theme = function()
      is_dark_theme = not is_dark_theme
      -- Set vim background to match the theme
      vim.o.background = is_dark_theme and 'dark' or 'light'
      -- Reconfigure tokyonight with current settings
      setup_catppuccin(bg_transparent)
      -- Reload the colorscheme to apply changes
      vim.cmd [[colorscheme catppuccin]]
    end

    -- Function to refresh theme based on current system settings
    local refresh_system_theme = function()
      local current_system_theme = utils.detect_system_theme()
      if current_system_theme ~= is_dark_theme then
        is_dark_theme = current_system_theme
        vim.o.background = is_dark_theme and 'dark' or 'light'
        setup_catppuccin(bg_transparent)
        vim.cmd [[colorscheme catppuccin]]
      end
    end

    -- Initial setup with detected theme
    setup_catppuccin(bg_transparent)
    vim.o.background = is_dark_theme and 'dark' or 'light'
    vim.cmd [[colorscheme catppuccin]]

    -- Set up the keymaps
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<leader>bgt', toggle_transparency, vim.tbl_extend('force', opts, { desc = 'Toggle theme background transparency' }))
    vim.keymap.set('n', '<leader>bgs', toggle_theme, vim.tbl_extend('force', opts, { desc = "Toggle between the theme's Light/Dark modes" }))
    vim.keymap.set('n', '<leader>bgr', refresh_system_theme, vim.tbl_extend('force', opts, { desc = 'Get the theme mode based on the host OS' }))
  end,
}
