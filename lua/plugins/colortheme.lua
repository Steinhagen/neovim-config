return {
  'folke/tokyonight.nvim',
  lazy = false, -- make sure we load this during startup
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- Initial states
    local bg_transparent = true

    -- Function to detect system theme
    local function detect_system_theme()
      local is_dark_theme = true -- default fallback

      -- Detect macOS appearance
      if vim.fn.has 'macunix' == 1 then
        if vim.fn.executable 'defaults' == 1 then
          local handle = io.popen 'defaults read -g AppleInterfaceStyle 2>/dev/null'
          if handle then
            local result = handle:read '*a'
            handle:close()
            -- If the command returns 'Dark', we're in dark mode
            -- If it fails/returns empty, we're in light mode
            is_dark_theme = result:match 'Dark' ~= nil
          end
        end

      -- Alternative Linux method using busctl (systemd/freedesktop portal)
      elseif vim.fn.executable 'busctl' == 1 then
        local handle =
          io.popen 'busctl --user call org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings ReadOne ss "org.freedesktop.appearance" "color-scheme" 2>/dev/null'
        if handle then
          local result = handle:read '*a'
          handle:close()
          -- The result format is "v u 1" for dark mode, "v u 0" for light mode
          local color_scheme = result:match 'u%s+(%d+)'
          is_dark_theme = color_scheme == '1'
        end
      end

      return is_dark_theme
    end

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
      }
    end

    -- Auto-detect system theme on startup
    local is_dark_theme = detect_system_theme()

    -- Toggle background transparency
    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      -- Reconfigure tokyonight with current settings
      setup_tokyonight(bg_transparent)
      -- Reload the colorscheme to apply changes
      vim.cmd [[colorscheme tokyonight]]
    end

    -- Toggle between dark and light themes (manual override)
    local toggle_theme = function()
      is_dark_theme = not is_dark_theme
      -- Set vim background to match the theme
      vim.o.background = is_dark_theme and 'dark' or 'light'
      -- Reconfigure tokyonight with current settings
      setup_tokyonight(bg_transparent)
      -- Reload the colorscheme to apply changes
      vim.cmd [[colorscheme tokyonight]]
    end

    -- Function to refresh theme based on current system settings
    local refresh_system_theme = function()
      local current_system_theme = detect_system_theme()
      if current_system_theme ~= is_dark_theme then
        is_dark_theme = current_system_theme
        vim.o.background = is_dark_theme and 'dark' or 'light'
        setup_tokyonight(bg_transparent)
        vim.cmd [[colorscheme tokyonight]]
      end
    end

    -- Initial setup with detected theme
    setup_tokyonight(bg_transparent)
    vim.o.background = is_dark_theme and 'dark' or 'light'
    vim.cmd [[colorscheme tokyonight]]

    -- Set up the keymaps
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<leader>bgt', toggle_transparency, vim.tbl_extend('force', opts, { desc = 'Toggle theme background transparency' }))
    vim.keymap.set('n', '<leader>bgs', toggle_theme, vim.tbl_extend('force', opts, { desc = "Toggle between the theme's Light/Dark modes" }))
    vim.keymap.set('n', '<leader>bgr', refresh_system_theme, vim.tbl_extend('force', opts, { desc = 'Get the theme mode based on the host OS' }))
  end,
}
