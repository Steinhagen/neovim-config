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

-- Load plugins using the default 'pack' package manager
require 'plugins.image'
require 'plugins.lsp'
require 'plugins.nvim-dap-view'
require 'plugins.snacks'
require 'plugins.pj' -- depends on 'snacks'
require 'plugins.opencode' -- depends on 'snacks'
require 'plugins.toggleterm'
require 'plugins.treesitter'
require 'plugins.nvim-regexplainer' -- depends on treesitter
require 'plugins.render-markdown' -- depends on treesitter
require 'plugins.vim-tmux-navigator'

-- Load plugins using the 'lazy' package manager
require('lazy').setup({
  require 'plugins.colortheme',
  require 'plugins.lualine',
  require 'plugins.codecompanion',
  require 'plugins.gitsigns',
  require 'plugins.autocompletion',
  require 'plugins.none-ls',
  require 'plugins.alpha',
  require 'plugins.indent-blankline',
  require 'plugins.conform',
  require 'plugins.visual-whitespace',
  require 'plugins.tiny-inline-diagnostic',
  require 'plugins.sessions',
  require 'plugins.neovim-tips',
  require 'plugins.nvim-ufo',
  require 'plugins.undo-glow',
  require 'plugins.typst-preview',
  require 'plugins.misc',
}, {
  -- By default, lazy.nvim takes full control of Neovim's runtime path (RTP) and
  -- deletes the default directories where Neovim 0.12's vim.pack installs things.
  -- Setting reset = false tells Lazy to leave those default paths alone so
  -- vim.pack can safely load the plugins right after Lazy finishes.

  performance = {
    rtp = {
      reset = false,
    },
    reset_packpath = false,
  },
})
