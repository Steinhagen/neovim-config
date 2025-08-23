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

return M
