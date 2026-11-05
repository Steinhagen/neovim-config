vim.g.tmux_navigator_no_mappings = 1

local map = vim.keymap.set
map({ 'n', 'v', 's' }, '<C-M-h>', ':<C-U>TmuxNavigateLeft<cr>', { silent = true })
map({ 'n', 'v', 's' }, '<C-M-j>', ':<C-U>TmuxNavigateDown<cr>', { silent = true })
map({ 'n', 'v', 's' }, '<C-M-k>', ':<C-U>TmuxNavigateUp<cr>', { silent = true })
map({ 'n', 'v', 's' }, '<C-M-l>', ':<C-U>TmuxNavigateRight<cr>', { silent = true })
