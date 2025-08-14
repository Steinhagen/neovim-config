local M = {}

--- Convert a numeric or string color to a hex string.
-- @param color number|string  Either a 0xRRGGBB integer or a hex string.
-- @return string             A `#RRGGBB` hex color.
function M.to_hex(color)
  if type(color) == 'number' then
    return string.format('#%06x', color)
  end
  return color or ''
end

return M
