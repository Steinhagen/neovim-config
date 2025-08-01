return {
  'akinsho/toggleterm.nvim',
  config = function()
    require('toggleterm').setup {
      open_mapping = '<C-t>',
      start_in_insert = true,
      direction = 'float',
      float_opts = {
        border = 'curved',
      },
    }
    vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n><cmd>q<cr>') -- Enter Normal mode
  end,
}
