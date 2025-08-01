return {
  'stevearc/conform.nvim',
  event = 'VeryLazy',
  keys = {
    {
      '<C-s><C-f>',
      function()
        require('conform').format {
          timeout_ms = 3000,
          lsp_fallback = true,
        }
      end,
      mode = '',
    },
  },
  opts = {
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
  },
}
