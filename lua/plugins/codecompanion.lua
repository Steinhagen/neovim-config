local mapping_key_prefix = vim.g.ai_prefix_key or '<leader>a'

return {
  'olimorris/codecompanion.nvim',
  lazy = false,
  opts = {
    strategies = {
      chat = { adapter = 'kiro' },
      inline = { adapter = 'kiro' },
    },

    adapters = {
      http = {
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
            env = {
              api_key = os.getenv 'GEMINI_API_KEY',
            },
            schema = {
              model = {
                default = 'gemini-3-flash-preview',
              },
            },
          })
        end,
      },
    },
  },

  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate',
      config = function()
        require('nvim-treesitter')
          .install({
            'lua',
            'markdown',
            'markdown_inline',
            'yaml',
          }, { summary = false, max_jobs = 10 })
          :wait(1800000)
      end,
    },
    {
      'echasnovski/mini.diff',
      config = function()
        local diff = require 'mini.diff'
        diff.setup {
          source = diff.gen_source.none(),
        }
      end,
    },
  },

  keys = {
    { mapping_key_prefix .. 'a', '<cmd>CodeCompanionActions<cr>', desc = 'Code Companion - Actions' },
    { mapping_key_prefix .. 't', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Code Companion - Toggle', mode = { 'n', 'v' } },
    { mapping_key_prefix .. 'e', '<cmd>CodeCompanion /explain<cr>', desc = 'Code Companion - Explain code', mode = 'v' },
    { mapping_key_prefix .. 'f', '<cmd>CodeCompanion /fix<cr>', desc = 'Code Companion - Fix code', mode = 'v' },
    { mapping_key_prefix .. 'l', '<cmd>CodeCompanion /lsp<cr>', desc = 'Code Companion - Explain LSP', mode = { 'n', 'v' } },
    { mapping_key_prefix .. 'T', '<cmd>CodeCompanion /tests<cr>', desc = 'Code Companion - Generate tests', mode = 'v' },
    { mapping_key_prefix .. 'm', '<cmd>CodeCompanion /staged-commit<cr>', desc = 'Code Companion - Commit msg' },
    { mapping_key_prefix .. 'd', '<cmd>CodeCompanion /inline-doc<cr>', desc = 'Code Companion - Inline docs', mode = 'v' },
    { mapping_key_prefix .. 'D', '<cmd>CodeCompanion /doc<cr>', desc = 'Code Companion - Docs', mode = 'v' },
    { mapping_key_prefix .. 'r', '<cmd>CodeCompanion /refactor<cr>', desc = 'Code Companion - Refactor', mode = 'v' },
    { mapping_key_prefix .. 'R', '<cmd>CodeCompanion /review<cr>', desc = 'Code Companion - Review', mode = 'v' },
    { mapping_key_prefix .. 'n', '<cmd>CodeCompanion /naming<cr>', desc = 'Code Companion - Better naming', mode = 'v' },
  },
}
