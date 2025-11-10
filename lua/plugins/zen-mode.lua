return {
  'folke/zen-mode.nvim',
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    { '<leader>Z', '<cmd>ZenMode<cr>', mode = { 'n', 'x' }, desc = 'Toggle Zen Mode' },
  },
}
