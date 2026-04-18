-- nui.nvim is already installed via nvim-regexplainer
vim.pack.add({
  'https://github.com/saxon1964/neovim-tips',
}, { confirm = false })

-- Defer setup until one of the keybinds is pressed
local initialized = false
local function ensure_setup()
  if not initialized then
    require('neovim-tips').setup {
      user_file = vim.fn.stdpath 'config' .. '/lua/plugins/data/neovim-tips/user-tips.txt',
      daily_tip = 0,
      quiet = true,
      bookmark_symbol = '🌟 ',
    }
    initialized = true
  end
end

local keys = {
  { '<leader>nto', ':NeovimTips<CR>', 'Neovim tips' },
  { '<leader>ntb', ':NeovimTipsBookmarks<CR>', 'Bookmarked tips' },
  { '<leader>ntr', ':NeovimTipsRandom<CR>', 'Show random tip' },
  { '<leader>nte', ':NeovimTipsEdit<CR>', 'Edit your tips' },
  { '<leader>nta', ':NeovimTipsAdd<CR>', 'Add your tip' },
  { '<leader>ntp', ':NeovimTipsPdf<CR>', 'Open tips PDF' },
}

for _, key in ipairs(keys) do
  vim.keymap.set('n', key[1], function()
    ensure_setup()
    vim.cmd(key[2]:sub(2)) -- strip leading ':'
  end, { desc = key[3] })
end
