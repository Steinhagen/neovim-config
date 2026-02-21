vim.g.tmux_navigator_no_mappings = 1

vim.pack.add({
  'https://github.com/christoomey/vim-tmux-navigator',
}, { confirm = false })

local map = vim.keymap.set
map({ 'n', 'v', 's' }, '<C-M-h>', ':<C-U>TmuxNavigateLeft<cr>', { silent = true })
map({ 'n', 'v', 's' }, '<C-M-j>', ':<C-U>TmuxNavigateDown<cr>', { silent = true })
map({ 'n', 'v', 's' }, '<C-M-k>', ':<C-U>TmuxNavigateUp<cr>', { silent = true })
map({ 'n', 'v', 's' }, '<C-M-l>', ':<C-U>TmuxNavigateRight<cr>', { silent = true })
