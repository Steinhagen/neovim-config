return {
  'emmanueltouzery/apidocs.nvim',
  lazy = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'folke/snacks.nvim',
  },
  config = function()
    require('apidocs').ensure_install {
      'c',
      'cpp',
      'rust',
      'cmake',
      'qt~6.9',
    }
    require('apidocs').setup()
  end,
  keys = {
    { '<leader>k', '<cmd>ApidocsOpen<cr>', desc = 'Search API Documentation', mode = { 'n', 'v' } },
  },
}
