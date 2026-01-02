local utils = require 'utils.system'

return {
  -- Ensure dependencies are installed
  { 'jayp0521/mason-null-ls.nvim', cond = not utils.is_nixos() },

  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
    },
    config = function()
      -- Variable to track if auto-formatting is enabled or disabled
      local format_on_save_enabled = false

      -- The function to toggle the state of auto-formatting
      local function toggle_autoformat()
        format_on_save_enabled = not format_on_save_enabled
        if format_on_save_enabled then
          vim.notify('Auto-formatting on save: ENABLED', vim.log.levels.INFO)
        else
          vim.notify('Auto-formatting on save: DISABLED', vim.log.levels.WARN)
        end
      end

      -- The keymap is now set here to call the toggle function
      vim.keymap.set('n', '<leader>f', toggle_autoformat, { noremap = true, silent = true, desc = 'Toggle format on save' })

      local null_ls = require 'null-ls'
      local util = require 'lspconfig.util'
      local formatting = null_ls.builtins.formatting -- to setup formatters

      if not utils.is_nixos() then
        -- Formatters & linters for mason to install
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

      local sources = {
        null_ls.builtins.diagnostics.checkmake.with {
          -- Dynamically find the config file in the project root
          extra_args = function(params)
            -- Find the root directory containing .git
            local root = util.root_pattern '.git'(params.bufname) or vim.loop.cwd()
            local config_file = root .. '/.checkmake.ini'
            -- Only add the flag if the file actually exists
            if vim.fn.filereadable(config_file) == 1 then
              return { '--config', config_file }
            end
            return {}
          end,
        },
        formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
        formatting.stylua,
        formatting.shfmt.with { args = { '-i', '4' } },
        formatting.terraform_fmt,
        require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
        require 'none-ls.formatting.ruff_format',
      }

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      null_ls.setup {
        -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
        sources = sources,
        -- you can reuse a shared lspconfig on_attach callback here
        on_attach = function(client, bufnr)
          if client:supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                -- Check the state variable before formatting
                if format_on_save_enabled then
                  vim.lsp.buf.format { async = false }
                end
              end,
            })
          end
        end,
      }
    end,
  },
}
