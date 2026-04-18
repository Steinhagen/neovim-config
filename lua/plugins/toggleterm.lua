vim.pack.add({
  'https://github.com/akinsho/toggleterm.nvim',
}, { confirm = false })

-- Defer setup until the toggle keybind is first pressed
local toggled = false
vim.keymap.set({ 'n', 't' }, [[<C-\>]], function()
  if not toggled then
    require('toggleterm').setup {
      open_mapping = [[<C-\>]],
      start_in_insert = true,
      direction = 'float',
      float_opts = { border = 'curved' },
    }
    toggled = true
  end
  vim.cmd 'ToggleTerm'
end, { desc = 'Toggle terminal' })
