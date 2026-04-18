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
-- The result is cached to avoid repeated disk I/O on every call.
-- @return boolean  true when on a NixOS Linux desktop, false otherwise
local _is_nixos = nil

function M.is_nixos()
  if _is_nixos == nil then
    _is_nixos = vim.uv.os_uname().sysname == 'Linux' and is_linux_nixos()
  end
  return _is_nixos
end

return M
