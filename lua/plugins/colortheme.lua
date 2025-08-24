return {
  (function()
    -- Define all your themes in here
    local themes = {
      catppuccin = {
        plugin = 'catppuccin/nvim',
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
        plugin = 'folke/tokyonight.nvim',
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

    -- This is the name of the active theme
    local current_theme_name = 'catppuccin'

    -- Force a specific theme via the environment variables
    -- Available themes: 'catppuccin', 'tokyonight'
    if vim.env.NVIM_THEME_NAME and themes[vim.env.NVIM_THEME_NAME] then
      current_theme_name = vim.env.NVIM_THEME_NAME
    end

    local active_theme = themes[current_theme_name]
    if not active_theme then
      vim.notify('Theme "' .. current_theme_name .. '" not found in configuration.', vim.log.levels.ERROR)
      return {} -- Return empty spec to avoid errors
    end

    -- Return the plugin spec for lazy.nvim
    return {
      active_theme.plugin,
      as = active_theme.colorscheme, -- Use 'as' in case the plugin name is different
      lazy = false,
      priority = 1000,
      config = function()
        local utils = require 'utils.theme'

        -- Initial states
        local bg_transparent = false -- Set your default transparency
        local is_dark_theme = utils.detect_system_theme()

        -- Generic function to setup and apply the current theme
        local apply_theme = function()
          -- 1. Get the correct options based on transparency
          local theme_opts = active_theme.opts(bg_transparent)
          -- 2. Call the theme's setup function
          require(active_theme.colorscheme).setup(theme_opts)
          -- 3. Set the colorscheme
          vim.cmd.colorscheme(active_theme.colorscheme)
        end

        -- Toggle background transparency
        local toggle_transparency = function()
          bg_transparent = not bg_transparent
          apply_theme()
          vim.notify('Transparency ' .. (bg_transparent and 'enabled' or 'disabled'))
        end

        -- Toggle between dark and light themes
        local toggle_theme = function()
          is_dark_theme = not is_dark_theme
          vim.o.background = is_dark_theme and 'dark' or 'light'
          apply_theme()
          vim.notify('Theme set to ' .. (is_dark_theme and 'dark' or 'light'))
        end

        -- Function to refresh theme based on system settings
        local refresh_system_theme = function()
          local current_system_theme = utils.detect_system_theme()
          if current_system_theme ~= is_dark_theme then
            is_dark_theme = current_system_theme
            vim.o.background = is_dark_theme and 'dark' or 'light'
            apply_theme()
            vim.notify('System theme changed to ' .. (is_dark_theme and 'dark' or 'light'))
          end
        end

        -- Initial setup
        vim.o.background = is_dark_theme and 'dark' or 'light'
        apply_theme()

        -- Set up the keymaps
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '<leader>bgt', toggle_transparency, vim.tbl_extend('force', opts, { desc = 'Toggle BG transparency' }))
        vim.keymap.set('n', '<leader>bgs', toggle_theme, vim.tbl_extend('force', opts, { desc = 'Toggle Light/Dark mode' }))
        vim.keymap.set('n', '<leader>bgr', refresh_system_theme, vim.tbl_extend('force', opts, { desc = 'Refresh system theme' }))
      end,
    }
  end)(),
}
