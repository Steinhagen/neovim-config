local utils = require 'utils.system'

-- Conditionally build your plugin list based on your NixOS check
local plugins = {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/nvimtools/none-ls-extras.nvim',
}

if not utils.is_nixos() then
  table.insert(plugins, 'https://github.com/jayp0521/mason-null-ls.nvim')
end

-- Install and load the plugins natively
vim.pack.add(plugins, { confirm = false })

-- Formatting State & Logic
local format_on_save_enabled = false

local function toggle_autoformat()
  format_on_save_enabled = not format_on_save_enabled
  if format_on_save_enabled then
    vim.notify('Auto-formatting on save: ENABLED', vim.log.levels.INFO)
  else
    vim.notify('Auto-formatting on save: DISABLED', vim.log.levels.WARN)
  end
end

-- Keymap to toggle format on save
vim.keymap.set('n', '<leader>f', toggle_autoformat, { noremap = true, silent = true, desc = 'Toggle format on save' })

-- Mason Integration (Skip if on NixOS)
if not utils.is_nixos() then
  require('mason-null-ls').setup {
    ensure_installed = {
      'prettier', -- ts/js formatter
      'eslint_d', -- ts/js linter
      'shfmt', -- Shell formatter
      'checkmake', -- linter for Makefiles
    },
    automatic_installation = true,
  }
end

-- None-LS Setup
local null_ls = require 'null-ls'
local util = require 'lspconfig.util'
local formatting = null_ls.builtins.formatting
local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

null_ls.setup {
  sources = {
    -- Diagnostics: checkmake
    null_ls.builtins.diagnostics.checkmake.with {
      extra_args = function(params)
        local root = util.root_pattern '.git'(params.bufname) or vim.loop.cwd()
        local config_file = root .. '/.checkmake.ini'
        if vim.fn.filereadable(config_file) == 1 then
          return { '--config', config_file }
        end
        return {}
      end,
    },
    -- Formatters
    formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
    formatting.stylua,
    formatting.shfmt.with { args = { '-i', '4' } },
    formatting.terraform_fmt,
    require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
    require 'none-ls.formatting.ruff_format',
  },
  on_attach = function(client, bufnr)
    if client:supports_method 'textDocument/formatting' then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          if format_on_save_enabled then
            vim.lsp.buf.format { async = false }
          end
        end,
      })
    end
  end,
}
