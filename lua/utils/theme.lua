local M = {}

local cache_file = vim.fn.stdpath 'data' .. '/theme_cache'

-- Function to detect system theme.
-- @return boolean        true if the Linux machine has a dark theme
function M.detect_system_theme()
  local is_dark_theme = true -- default fallback

  -- See if the theme is forced to a mode
  if vim.env.NVIM_THEME_MODE == 'light' then
    return false
  elseif vim.env.NVIM_THEME_MODE == 'dark' then
    return true
  end

  -- Try reading cached value first (avoids subprocess on startup)
  local f = io.open(cache_file, 'r')
  if f then
    local cached = f:read '*a'
    f:close()
    if cached == 'dark' then
      -- Schedule a background refresh so next startup is accurate
      vim.schedule(function() M._refresh_cache() end)
      return true
    elseif cached == 'light' then
      vim.schedule(function() M._refresh_cache() end)
      return false
    end
  end

  -- No cache — detect and write cache
  is_dark_theme = M._detect_raw()
  M._write_cache(is_dark_theme)
  return is_dark_theme
end

function M._detect_raw()
  -- Detect macOS appearance
  if vim.fn.has 'macunix' == 1 then
    if vim.fn.executable 'defaults' == 1 then
      local handle = io.popen 'defaults read -g AppleInterfaceStyle 2>/dev/null'
      if handle then
        local result = handle:read '*a'
        handle:close()
        return result:match 'Dark' ~= nil
      end
    end
  -- Detect Linux appearance using busctl (systemd/freedesktop portal)
  elseif vim.fn.executable 'busctl' == 1 then
    local handle =
      io.popen 'busctl --user call org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings ReadOne ss "org.freedesktop.appearance" "color-scheme" 2>/dev/null'
    if handle then
      local result = handle:read '*a'
      handle:close()
      local color_scheme = result:match 'u%s+(%d+)'
      return color_scheme == '1'
    end
  end
  return true
end

function M._write_cache(is_dark)
  local wf = io.open(cache_file, 'w')
  if wf then
    wf:write(is_dark and 'dark' or 'light')
    wf:close()
  end
end

function M._refresh_cache()
  local current = M._detect_raw()
  M._write_cache(current)
end

return M
