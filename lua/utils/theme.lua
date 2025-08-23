local M = {}

-- Function to detect system theme.
-- @return boolean        true if the Linux machine has a dark theme
function M.detect_system_theme()
  local is_dark_theme = true -- default fallback

  -- See if the theme is forced to a mode
  if vim.env.NVIM_THEME_MODE == 'light' then
    is_dark_theme = false
  elseif vim.env.NVIM_THEME_MODE == 'dark' then
    is_dark_theme = true

    -- Detect macOS appearance
  elseif vim.fn.has 'macunix' == 1 then
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

    -- Detect Linux appearance using busctl (systemd/freedesktop portal)
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

return M
