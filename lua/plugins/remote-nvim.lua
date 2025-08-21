return {
  -- 'amitds1997/remote-nvim.nvim',
  'thienandangthanh/remote-nvim.nvim',
  branch = 'fix/incorrect-script-installation-file-reference',
  dependencies = {
    'nvim-lua/plenary.nvim', -- For standard functions
    'MunifTanjim/nui.nvim', -- To build the plugin UI
    'nvim-telescope/telescope.nvim', -- For picking b/w different remote methods
  },
  config = function()
    require('remote-nvim').setup {
      remote = {
        copy_dirs = {
          config = {
            compression = {
              enabled = true,
              additional_opts = { '--exclude-vcs' },
            },
          },
        },
      },
    }

    vim.keymap.set('n', '<leader>rc', '<cmd>RemoteStart<CR>', { desc = 'Remote: Start/Connect' })
    vim.keymap.set('n', '<leader>ri', '<cmd>RemoteInfo<CR>', { desc = 'Remote: Info' })
    vim.keymap.set('n', '<leader>rl', '<cmd>RemoteLog<CR>', { desc = 'Remote: Log' })
    vim.keymap.set('n', '<leader>rd', '<cmd>RemoteStop<CR>', { desc = 'Remote: Stop/Disconnect' })
  end,
}
