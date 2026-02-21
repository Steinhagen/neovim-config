vim.pack.add({
  'https://github.com/josephschmitt/pj.nvim',
}, { confirm = false })

require('pj').setup {}

vim.keymap.set('n', '<leader>fP', '<cmd>Pj<cr>', { desc = 'Find Projects' })
