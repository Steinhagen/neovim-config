local api = vim.api
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

-- Safely get a highlight color and convert to hex
local function get_hl_hex(group, kind)
  local ok, hl = pcall(api.nvim_get_hl, 0, { name = group })
  return M.to_hex(ok and hl[kind] or nil)
end

-- Exported theme colors
M.normal_bg = get_hl_hex('TabLine', 'bg')
M.title_fg = get_hl_hex('Directory', 'fg')
M.select_fg = get_hl_hex('WildMenu', 'fg')
M.ask_fg = get_hl_hex('WarningMsg', 'fg')
M.normal_fg = get_hl_hex('Normal', 'fg')
M.spellbad_fg = get_hl_hex('SpellBad', 'fg')
M.question_fg = get_hl_hex('Question', 'fg')
M.diffchange_fg = get_hl_hex('DiffChange', 'fg')
M.removed_fg = get_hl_hex('Removed', 'fg')

return M
