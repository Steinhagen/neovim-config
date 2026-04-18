vim.pack.add({
  'https://github.com/chomosuke/typst-preview.nvim',
}, { confirm = false })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typst',
  once = true,
  callback = function()
    require('typst-preview').setup {
      backend = 'tinymist',
      dependencies_bin = {
        tinymist = vim.fn.exepath 'tinymist',
        websocat = nil,
      },
    }
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'typst',
  callback = function()
    vim.keymap.set('n', '<leader>tv', ':TypstPreviewToggle<CR>', { buffer = true, desc = 'Toggle Typst Preview' })
  end,
})
