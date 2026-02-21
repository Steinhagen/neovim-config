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

-- Load plugins using the 'lazy' package manager
require('lazy').setup({
  require 'plugins.colortheme',
  require 'plugins.lualine',
  require 'plugins.codecompanion',
  require 'plugins.opencode',
  require 'plugins.treesitter',
  require 'plugins.gitsigns',
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  require 'plugins.none-ls',
  require 'plugins.alpha',
  require 'plugins.indent-blankline',
  require 'plugins.conform',
  require 'plugins.toggleterm',
  require 'plugins.visual-whitespace',
  require 'plugins.tiny-inline-diagnostic',
  require 'plugins.render-markdown',
  require 'plugins.sessions',
  require 'plugins.neovim-tips',
  require 'plugins.nvim-dap-view',
  require 'plugins.nvim-regexplainer',
  require 'plugins.nvim-ufo',
  require 'plugins.pj',
  require 'plugins.undo-glow',
  require 'plugins.vim-tmux-navigator',
  require 'plugins.typst-preview',
  require 'plugins.snacks',
  require 'plugins.misc',
}, {
  -- By default, lazy.nvim takes full control of Neovim's runtime path (RTP) and
  -- deletes the default directories where Neovim 0.12's vim.pack installs things.
  -- Setting reset = false tells Lazy to leave those default paths alone so
  -- vim.pack can safely load image.nvim right after Lazy finishes.

  performance = {
    rtp = {
      reset = false,
    },
    reset_packpath = false,
  },
})
