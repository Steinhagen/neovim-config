return {
  'nosduco/remote-sshfs.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },
  cmd = {
    'RemoteSSHFSConnect',
    'RemoteSSHFSDisconnect',
    'RemoteSSHFSEdit',
    'RemoteSSHFSFindFiles',
    'RemoteSSHFSLiveGrep',
  },
  keys = {
    {
      '<leader>rc',
      function()
        require('remote-sshfs.api').connect()
      end,
      desc = 'Remote SSH Connect',
      noremap = true,
    },
    {
      '<leader>rd',
      function()
        require('remote-sshfs.api').disconnect()
      end,
      desc = 'Remote SSH Disconnect',
      noremap = true,
    },
  },
  config = function()
    require('remote-sshfs').setup {
      connections = {
        ssh_configs = {
          vim.fn.expand '~' .. '/.ssh/config',
        },
      },
    }
    require('telescope').load_extension 'remote-sshfs'
  end,
}
