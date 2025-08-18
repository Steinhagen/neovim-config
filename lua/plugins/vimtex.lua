return {
  'lervag/vimtex',
  init = function()
    -- general options have to be set *before* the plug-in is loaded
    vim.g.vimtex_view_method = 'zathura' -- or "skim", "sioyek", "sumatrapdf" …
    vim.g.vimtex_mappings_prefix = ',' -- personal preference
    vim.g.vimtex_quickfix_mode = 0 -- don’t open quickfix automatically
  end,
  config = function()
    -- optional extra key-maps
    vim.keymap.set('n', '<leader>Lc', '<plug>(vimtex-compile)', { desc = 'VimTeX compile' })
    vim.keymap.set('n', '<leader>Lv', '<plug>(vimtex-view)', { desc = 'VimTeX view PDF' })
  end,
  ft = { 'tex', 'plaintex', 'latex' },
}
