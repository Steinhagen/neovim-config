-- Theme definitions live in lua/core/themes.lua (shared with core/pack.lua,
-- which installs the active theme plugin).
local themes = require 'core.themes'

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
  return
end

-- Apply theme immediately (no deferral — colorscheme must load first)
local utils = require 'utils.theme'

local bg_transparent = false
local is_dark_theme = utils.detect_system_theme()

local apply_theme = function()
  local theme_opts = active_theme.opts(bg_transparent)
  require(active_theme.colorscheme).setup(theme_opts)
  vim.cmd.colorscheme(active_theme.colorscheme)
end

local toggle_transparency = function()
  bg_transparent = not bg_transparent
  apply_theme()
  vim.notify('Transparency ' .. (bg_transparent and 'enabled' or 'disabled'))
end

local toggle_theme = function()
  is_dark_theme = not is_dark_theme
  vim.o.background = is_dark_theme and 'dark' or 'light'
  apply_theme()
  vim.notify('Theme set to ' .. (is_dark_theme and 'dark' or 'light'))
end

local refresh_system_theme = function()
  local current_system_theme = utils.detect_system_theme()
  if current_system_theme ~= is_dark_theme then
    is_dark_theme = current_system_theme
    vim.o.background = is_dark_theme and 'dark' or 'light'
    apply_theme()
    vim.notify('System theme changed to ' .. (is_dark_theme and 'dark' or 'light'))
  end
end

vim.o.background = is_dark_theme and 'dark' or 'light'
apply_theme()

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>bgt', toggle_transparency, vim.tbl_extend('force', opts, { desc = 'Toggle BG transparency' }))
vim.keymap.set('n', '<leader>bgs', toggle_theme, vim.tbl_extend('force', opts, { desc = 'Toggle Light/Dark mode' }))
vim.keymap.set('n', '<leader>bgr', refresh_system_theme, vim.tbl_extend('force', opts, { desc = 'Refresh system theme' }))
