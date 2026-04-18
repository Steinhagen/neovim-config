-- Capture startup time before anything else
local _start = vim.fn.reltime()

-- Enable Lua bytecode caching for faster require() calls
vim.loader.enable()

require 'core.options'
require 'core.menu'
require 'core.keymaps'

require 'plugins.colortheme'
require 'plugins.lsp'
require 'plugins.none-ls'
require 'plugins.nvim-dap-view'
require 'plugins.toggleterm'
require 'plugins.treesitter'
require 'plugins.nvim-regexplainer'
require 'plugins.render-markdown'
require 'plugins.vim-tmux-navigator'
require 'plugins.gitsigns'
require 'plugins.indent-blankline'
require 'plugins.conform'
require 'plugins.visual-whitespace'
require 'plugins.nvim-ufo'
require 'plugins.neovim-tips'
require 'plugins.typst-preview'
require 'plugins.lualine'
require 'plugins.undo-glow'
require 'plugins.tiny-inline-diagnostic'
require 'plugins.sessions'
require 'plugins.misc'
require 'plugins.codecompanion'
require 'plugins.autocompletion'

-- Load snacks last so that the dashboard knows all loading times
vim.g.startup_ms = vim.fn.reltimefloat(vim.fn.reltime(_start)) * 1000
require 'plugins.snacks'
