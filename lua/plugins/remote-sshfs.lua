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
      '<leader>Rc',
      function()
        require('remote-sshfs.api').connect()
      end,
      desc = 'Remote SSH Connect',
      noremap = true,
    },
    {
      '<leader>Rd',
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
          vim.fn.expand '$HOME' .. '/.ssh/config',
        },
        ssh_known_hosts = vim.fn.expand '$HOME' .. '/.ssh/known_hosts',
        ui = {
          confirm = {
            connect = true,
          },
        },
      },
    }
    require('telescope').load_extension 'remote-sshfs'
  end,
}
