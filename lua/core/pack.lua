-- Every plugin source in one `vim.pack.add()` call.
--
-- Previously each `plugins/*.lua` file called `vim.pack.add()` itself, so startup
-- ran ~25 of them. vim.pack repeats its bookkeeping (lock sync, spec
-- normalization, `:packadd`) per call; batching removes the repeated call
-- overhead. The list is kept in the order the plugin files used to be required,
-- so 'runtimepath' precedence is unchanged.
local utils = require 'utils.system'
local themes = require 'core.themes'

-- Same selection rules as plugins/colortheme.lua
local function active_theme()
  local name = vim.env.NVIM_THEME_NAME
  if not (name and themes[name]) then
    name = 'catppuccin'
  end
  return themes[name]
end

local plugins = {
  -- colortheme
  active_theme().src,

  -- lsp
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  -- Mason plugins (Conditional for non-NixOS)
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',

  -- none-ls
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/nvimtools/none-ls-extras.nvim',

  -- nvim-dap-view
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/igorlfs/nvim-dap-view',

  -- toggleterm
  'https://github.com/akinsho/toggleterm.nvim',

  -- treesitter
  'https://github.com/nvim-treesitter/nvim-treesitter',

  -- nvim-regexplainer
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/bennypowers/nvim-regexplainer',

  -- render-markdown
  'https://github.com/echasnovski/mini.icons',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',

  -- vim-tmux-navigator
  'https://github.com/christoomey/vim-tmux-navigator',

  -- gitsigns
  'https://github.com/lewis6991/gitsigns.nvim',

  -- indent-blankline
  'https://github.com/lukas-reineke/indent-blankline.nvim',

  -- conform
  'https://github.com/stevearc/conform.nvim',

  -- visual-whitespace
  'https://github.com/mcauley-penney/visual-whitespace.nvim',

  -- nvim-ufo
  'https://github.com/kevinhwang91/promise-async',
  'https://github.com/kevinhwang91/nvim-ufo',

  -- neovim-tips
  'https://github.com/saxon1964/neovim-tips',

  -- typst-preview
  'https://github.com/chomosuke/typst-preview.nvim',

  -- lualine
  'https://github.com/nvim-lualine/lualine.nvim',

  -- undo-glow
  'https://github.com/y3owk1n/undo-glow.nvim',

  -- tiny-inline-diagnostic
  'https://github.com/rachartier/tiny-inline-diagnostic.nvim',

  -- sessions
  'https://github.com/rmagatti/auto-session',

  -- misc
  'https://github.com/tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'https://github.com/folke/which-key.nvim', -- Hints keybinds
  'https://github.com/windwp/nvim-autopairs', -- Autoclose parentheses, brackets, quotes, etc.
  'https://github.com/folke/todo-comments.nvim', -- Highlight todo, notes, etc in comments
  'https://github.com/catgoose/nvim-colorizer.lua', -- High-performance color highlighter

  -- codecompanion
  'https://github.com/echasnovski/mini.diff',
  'https://github.com/olimorris/codecompanion.nvim',

  -- autocompletion
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/saadparwaiz1/cmp_luasnip',
  'https://github.com/hrsh7th/cmp-buffer',
  'https://github.com/hrsh7th/cmp-path',

  -- bitwise-visualizer
  'https://github.com/wellatleastitried/bitwise-visualizer.nvim',

  -- snacks
  'https://github.com/folke/snacks.nvim',
}

-- mason-null-ls is only used outside NixOS (see plugins/none-ls.lua)
if not utils.is_nixos() then
  table.insert(plugins, 'https://github.com/jayp0521/mason-null-ls.nvim')
end

vim.pack.add(plugins, { confirm = false })
