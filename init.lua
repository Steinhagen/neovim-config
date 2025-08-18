require 'core.options'
require 'core.menu'
require 'core.keymaps'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup {
  require 'plugins.neotree',
  require 'plugins.colortheme',
  require 'plugins.bufferline',
  require 'plugins.lualine',
  require 'plugins.codecompanion',
  require 'plugins.treesitter',
  require 'plugins.gitsigns',
  require 'plugins.my-telescope',
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  require 'plugins.none-ls',
  require 'plugins.alpha',
  require 'plugins.indent-blankline',
  require 'plugins.remote-sshfs',
  require 'plugins.conform',
  require 'plugins.toggleterm',
  require 'plugins.visual-whitespace',
  require 'plugins.tiny-inline-diagnostic',
  require 'plugins.render-markdown',
  require 'plugins.sessions',
  require 'plugins.neovim-tips',
  require 'plugins.nvim-ufo',
  require 'plugins.undo-glow',
  require 'plugins.image',
  require 'plugins.vimtex',
  require 'plugins.misc',
}
