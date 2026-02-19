return {
  'christoomey/vim-tmux-navigator',
  init = function()
    vim.g.tmux_navigator_no_mappings = 1
    vim.keymap.set({"n", "v", "s"}, "<C-M-h>", ":<C-U>TmuxNavigateLeft<cr>", { silent = true })
    vim.keymap.set({"n", "v", "s"}, "<C-M-j>", ":<C-U>TmuxNavigateDown<cr>", { silent = true })
    vim.keymap.set({"n", "v", "s"}, "<C-M-k>", ":<C-U>TmuxNavigateUp<cr>", { silent = true })
    vim.keymap.set({"n", "v", "s"}, "<C-M-l>", ":<C-U>TmuxNavigateRight<cr>", { silent = true })
  end,
}
