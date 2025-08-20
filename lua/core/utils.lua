local api = vim.api
local M = {}

-- Verifies if a system is a NixOS machine.
-- @return boolean        true if the Linux machine is NixOS, false otherwise
local function is_linux_nixos()
  local f = io.open('/etc/os-release', 'r')
  if not f then
    return false
  end
  for line in f:lines() do
    if line:match '^ID=nixos' then
      f:close()
      return true
    end
  end
  f:close()
  return false
end

-- Returns true if running on a Linux system that is NixOS.
-- Uses `vim.uv.os_uname().sysname` to detect the OS kernel name,
-- and checks `/etc/os-release` via `is_nixos()` to exclude NixOS hosts.
-- @return boolean  true when on a NixOS Linux desktop, false otherwise
function M.is_nixos()
  return vim.uv.os_uname().sysname == 'Linux' and is_linux_nixos()
end

-- Convert a numeric or string color to a hex string.
-- @param color number|string  Either a 0xRRGGBB integer or a hex string.
-- @return string             A `#RRGGBB` hex color.
function M.to_hex(color)
  if type(color) == 'number' then
    return string.format('#%06x', color)
  end
  return color or ''
end

-- Safely get a highlight color and convert to hex
local function get_hl_hex(group, kind)
  local ok, hl = pcall(api.nvim_get_hl, 0, { name = group })
  return M.to_hex(ok and hl[kind] or nil)
end

-- Exported theme colors
M.normal_fg = get_hl_hex('Normal', 'fg')

M.dark_muted_orange = '#7A5A3D'
M.dark_muted_purple = '#5C475C'
M.dark_muted_pink = '#793D54'
M.dark_muted_cyan = '#325B5B'
M.dark_muted_yellow = '#7A683A'
M.dark_muted_green = '#2F4640'
M.dark_muted_red = '#693232'

return M
