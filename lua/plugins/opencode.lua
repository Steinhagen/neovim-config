vim.pack.add({
  "https://github.com/NickvanDyke/opencode.nvim"
}, { confirm = false })

vim.g.opencode_opts = {
  provider = {
    enabled = 'snacks', -- Default when `snacks.terminal` is enabled.
  },
}

vim.opt.autoread = true

local map = vim.keymap.set
map('n', '<leader>ot', function() require('opencode').toggle() end, { desc = 'Toggle' })
map('n', '<leader>oA', function() require('opencode').ask() end, { desc = 'Ask' })
map('n', '<leader>oa', function() require('opencode').ask('@cursor: ') end, { desc = 'Ask about this' })
map('v', '<leader>oa', function() require('opencode').ask('@selection: ') end, { desc = 'Ask about selection' })
map('n', '<leader>o+', function() require('opencode').append_prompt('@buffer') end, { desc = 'Add buffer to prompt' })
map('v', '<leader>o+', function() require('opencode').append_prompt('@selection') end, { desc = 'Add selection to prompt' })
map('n', '<leader>on', function() require('opencode').command('session_new') end, { desc = 'New session' })
map('n', '<leader>oy', function() require('opencode').command('messages_copy') end, { desc = 'Copy last response' })
map('n', '<S-C-u>', function() require('opencode').command('messages_half_page_up') end, { desc = 'Messages half page up' })
map('n', '<S-C-d>', function() require('opencode').command('messages_half_page_down') end, { desc = 'Messages half page down' })
map({ 'n', 'v' }, '<leader>os', function() require('opencode').select() end, { desc = 'Select prompt' })
map('n', '<leader>oe', function() require('opencode').prompt('Explain @cursor and its context') end, { desc = 'Explain this code' })
