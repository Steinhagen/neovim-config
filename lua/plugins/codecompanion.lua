local mapping_key_prefix = vim.g.ai_prefix_key or '<leader>a'

return {
  'olimorris/codecompanion.nvim',
  opts = {
    strategies = {
      chat = { adapter = 'gemini' }, -- ollama_chat
      inline = { adapter = 'gemini' }, -- ollama_inline,
    },

    adapters = {
      ollama_inline = function()
        return require('codecompanion.adapters').extend('ollama', {
          schema = {
            model = {
              default = 'gemma3:270m',
            },
          },
        })
      end,
      ollama_chat = function()
        return require('codecompanion.adapters').extend('ollama', {
          schema = {
            model = {
              default = 'gemma3:4b',
            },
          },
        })
      end,
      gemini = function()
        return require('codecompanion.adapters').extend('gemini', {
          -- url = 'https://generativelanguage.googleapis.com/v1beta/models/${model}:streamGenerateContent?alt=sse&key=${api_key}',
          env = {
            api_key = os.getenv 'GEMINI_API_KEY',
            -- model = 'schema.model.default',
            -- model = 'gemini-2.5-flash',
            default = 'gemini-2.5-pro',
          },
        })
      end,
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
      'echasnovski/mini.diff',
      config = function()
        local diff = require 'mini.diff'
        diff.setup {
          -- Disabled by default
          source = diff.gen_source.none(),
        }
      end,
    },
  },

  keys = {
    -- Recommend setup
    {
      mapping_key_prefix .. 'a',
      '<cmd>CodeCompanionActions<cr>',
      desc = 'Code Companion - Actions',
    },
    {
      mapping_key_prefix .. 't',
      '<cmd>CodeCompanionChat Toggle<cr>',
      desc = 'Code Companion - Toggle',
      mode = { 'n', 'v' },
    },
    -- Some common usages with visual mode
    {
      mapping_key_prefix .. 'e',
      '<cmd>CodeCompanion /explain<cr>',
      desc = 'Code Companion - Explain code',
      mode = 'v',
    },
    {
      mapping_key_prefix .. 'f',
      '<cmd>CodeCompanion /fix<cr>',
      desc = 'Code Companion - Fix code',
      mode = 'v',
    },
    {
      mapping_key_prefix .. 'l',
      '<cmd>CodeCompanion /lsp<cr>',
      desc = 'Code Companion - Explain LSP diagnostic',
      mode = { 'n', 'v' },
    },
    {
      mapping_key_prefix .. 'T',
      '<cmd>CodeCompanion /tests<cr>',
      desc = 'Code Companion - Generate unit test',
      mode = 'v',
    },
    {
      mapping_key_prefix .. 'm',
      '<cmd>CodeCompanion /staged-commit<cr>',
      desc = 'Code Companion - Git commit message (staged)',
    },
    {
      mapping_key_prefix .. 'd',
      '<cmd>CodeCompanion /inline-doc<cr>',
      desc = 'Code Companion - Inline document code',
      mode = 'v',
    },
    {
      mapping_key_prefix .. 'D',
      '<cmd>CodeCompanion /doc<cr>',
      desc = 'Code Companion - Document code',
      mode = 'v',
    },
    {
      mapping_key_prefix .. 'r',
      '<cmd>CodeCompanion /refactor<cr>',
      desc = 'Code Companion - Refactor code',
      mode = 'v',
    },
    {
      mapping_key_prefix .. 'R',
      '<cmd>CodeCompanion /review<cr>',
      desc = 'Code Companion - Review code',
      mode = 'v',
    },
    {
      mapping_key_prefix .. 'n',
      '<cmd>CodeCompanion /naming<cr>',
      desc = 'Code Companion - Better naming',
      mode = 'v',
    },
  },
}
