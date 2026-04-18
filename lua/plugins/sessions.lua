vim.pack.add({
  'https://github.com/rmagatti/auto-session',
}, { confirm = false })

local mapping_key_prefix = vim.g.ai_prefix_key or '<leader>S'

-- Defer setup until first buffer read/write
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufWritePre' }, {
  once = true,
  callback = function()
    require('auto-session').setup {
      enabled = true,
      root_dir = vim.fn.stdpath 'data' .. '/sessions/',
      auto_save = true,
      auto_restore = false,
      auto_create = true,
      suppressed_dirs = nil,
      allowed_dirs = nil,
      auto_restore_last_session = false,
      use_git_branch = true,
      lazy_support = true,
      bypass_save_filetypes = { 'alpha' },
      close_unsupported_windows = true,
      args_allow_single_directory = true,
      args_allow_files_auto_save = false,
      continue_restore_on_error = true,
      show_auto_restore_notif = false,
      cwd_change_handling = false,
      lsp_stop_on_restore = false,
      log_level = 'error',

      session_lens = {
        picker = 'snacks',
        mappings = {
          delete_session = { 'i', '<C-D>' },
          alternate_session = { 'i', '<C-S>' },
          copy_session = { 'i', '<C-Y>' },
        },
        session_control = {
          control_dir = vim.fn.stdpath 'data' .. '/auto_session/',
          control_filename = 'session_control.json',
        },
      },
    }
  end,
})

-- Keymaps (available immediately, commands will work once auto-session loads)
local opts = { noremap = true, silent = true }
vim.keymap.set({ 'n', 'x' }, mapping_key_prefix .. 's', '<cmd>AutoSession search<cr>', vim.tbl_extend('force', opts, { desc = 'Pick' }))
vim.keymap.set({ 'n', 'x' }, mapping_key_prefix .. 'r', '<cmd>AutoSession restore<cr>', vim.tbl_extend('force', opts, { desc = 'Restore' }))
vim.keymap.set({ 'n', 'x' }, mapping_key_prefix .. 'w', '<cmd>AutoSession save<cr>', vim.tbl_extend('force', opts, { desc = 'Save' }))
vim.keymap.set({ 'n', 'x' }, mapping_key_prefix .. 'd', '<cmd>AutoSession delete<cr>', vim.tbl_extend('force', opts, { desc = 'Delete' }))
vim.keymap.set({ 'n', 'x' }, mapping_key_prefix .. 't', '<cmd>AutoSession toggle<cr>', vim.tbl_extend('force', opts, { desc = 'Toggle Autosave' }))
