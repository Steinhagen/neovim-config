return {
  'saxon1964/neovim-tips',
  dependencies = { 'ibhagwan/fzf-lua' },
  opts = {
    -- OPTIONAL: Location of user defined tips (default value shown below)
    user_file = vim.fn.stdpath 'config' .. '/lua/plugins/data/neovim-tips/user-tips.txt',
    -- OPTIONAL: Show warnings when user tips conflict with builtin (default: true)
    user_tip_prefix = '[User] ',
    -- OPTIONAL: Show warnings when user tips conflict with builtin (default: true)
    warn_on_conflicts = true,
  },
  init = function()
    local map = vim.keymap.set
    map('n', '<leader>nto', ':NeovimTips<CR>', { desc = 'Neovim tips', noremap = true, silent = true })
    map('n', '<leader>nte', ':NeovimTipsEdit<CR>', { desc = 'Edit your Neovim tips', noremap = true, silent = true })
    map('n', '<leader>nta', ':NeovimTipsAdd<CR>', { desc = 'Add your Neovim tip', noremap = true, silent = true })
    map('n', '<leader>nth', ':NeovimTipsHelp<CR>', { desc = 'Neovim tips user guide', noremap = true, silent = true })
  end,
}
