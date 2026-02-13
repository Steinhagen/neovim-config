return {
  'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup {
      open_mapping = [[<C-\>]],
      start_in_insert = true,
      direction = 'float',
      float_opts = {
        border = 'curved',
      },
    }
  end,
}
