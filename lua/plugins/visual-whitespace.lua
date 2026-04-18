vim.pack.add({
  'https://github.com/mcauley-penney/visual-whitespace.nvim',
}, { confirm = false })

-- Only needed in visual mode, defer until first use
vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*:[vV\x16]*',
  once = true,
  callback = function()
    require('visual-whitespace').setup {
      enabled = true,
      highlight = { link = 'Visual', default = true },
      match_types = {
        space = true,
        tab = true,
        nbsp = true,
        lead = false,
        trail = false,
      },
      list_chars = {
        space = '·',
        tab = '↦',
        nbsp = '␣',
        lead = '‹',
        trail = '›',
      },
      fileformat_chars = {
        unix = '↲',
        mac = '←',
        dos = '↙',
      },
      ignore = { filetypes = {}, buftypes = {} },
    }
  end,
})
