-- Adds git related signs to the gutter, as well as utilities for managing changes
vim.pack.add({
  'https://github.com/lewis6991/gitsigns.nvim',
}, { confirm = false })

vim.api.nvim_create_autocmd('BufReadPre', {
  once = true,
  callback = function()
    require('gitsigns').setup {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged_enable = true,
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = false,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
    }

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<leader>gg', '<cmd>Gitsigns toggle_signs<CR>', vim.tbl_extend('force', opts, { desc = 'Git toggle signs' }))
    vim.keymap.set('n', '<leader>gM', '<cmd>Gitsigns blame_line<CR>', vim.tbl_extend('force', opts, { desc = 'Git blame line' }))
    vim.keymap.set('n', '<leader>gm', '<cmd>Gitsigns blame<CR>', vim.tbl_extend('force', opts, { desc = 'Git blame' }))
  end,
})
