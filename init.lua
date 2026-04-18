require 'core.options'
require 'core.menu'
require 'core.keymaps'

-- Load plugins using the default 'pack' package manager
require 'plugins.colortheme'
require 'plugins.lsp'
require 'plugins.none-ls' -- depends on lsp
require 'plugins.nvim-dap-view'
require 'plugins.toggleterm'
require 'plugins.treesitter'
require 'plugins.nvim-regexplainer' -- depends on treesitter
require 'plugins.render-markdown' -- depends on treesitter
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
require 'plugins.snacks'
