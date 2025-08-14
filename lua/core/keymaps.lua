-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<C-s><C-n>', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<leader>q', '<cmd> q <CR>', opts)

-- force quit all files
vim.keymap.set({ 'n', 'v' }, '<leader>qa', '<cmd> qa! <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -1<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +1<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -1<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +1<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', vim.tbl_extend('force', opts, { desc = 'Close buffer' }))
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', vim.tbl_extend('force', opts, { desc = 'New buffer' }))

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', vim.tbl_extend('force', opts, { desc = 'Split window vertically' }))
vim.keymap.set('n', '<leader>h', '<C-w>s', vim.tbl_extend('force', opts, { desc = 'Split window horizontally' }))
vim.keymap.set('n', '<leader>se', '<C-w>=', vim.tbl_extend('force', opts, { desc = 'Make split windows equal width & height' }))
vim.keymap.set('n', '<leader>xs', ':close<CR>', vim.tbl_extend('force', opts, { desc = 'Close current split window' }))

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', vim.tbl_extend('force', opts, { desc = 'Open new tab' }))
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', vim.tbl_extend('force', opts, { desc = 'Close current tab' }))
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', vim.tbl_extend('force', opts, { desc = 'Go to next tab' }))
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', vim.tbl_extend('force', opts, { desc = 'Go to previous tab' }))

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>dm', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
