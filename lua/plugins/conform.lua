vim.pack.add({
  'https://github.com/stevearc/conform.nvim',
}, { confirm = false })

vim.api.nvim_create_autocmd('BufReadPre', {
  once = true,
  callback = function()
    require('conform').setup {
      notify_on_error = true,

      formatters = {
        astyle = {
          command = 'astyle',
          prepend_args = {
            '--style=linux',
            '--indent=tab=8',
            '--min-conditional-indent=0',
            '--pad-oper',
            '--pad-header',
            '--unpad-paren',
            '--squeeze-lines=1',
            '--keep-one-line-blocks',
            '--keep-one-line-statements',
            '--lineend=linux',
          },
        },
      },
      formatters_by_ft = {
        c = { 'astyle' },
      },
    }
  end,
})

vim.keymap.set('', '<C-s><C-f>', function()
  require('conform').format {
    timeout_ms = 3000,
    lsp_fallback = true,
  }
end)
