vim.pack.add({
  'https://github.com/akinsho/toggleterm.nvim',
}, { confirm = false })

require('toggleterm').setup {
  open_mapping = [[<C-\>]],
  start_in_insert = true,
  direction = 'float',
  float_opts = {
    border = 'curved',
  },
}
