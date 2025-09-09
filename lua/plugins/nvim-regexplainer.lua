return {
  'bennypowers/nvim-regexplainer',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter' },
    { 'MunifTanjim/nui.nvim' },
  },
  event = { 'BufRead' },
  config = function()
    require('regexplainer').setup {
      -- automatically show the explainer when the cursor enters a regexp
      auto = true,
      display = 'popup',
      popup = {
        border = {
          padding = { 0, 0 },
          style = 'rounded',
        },
      },
    }
  end,
}
