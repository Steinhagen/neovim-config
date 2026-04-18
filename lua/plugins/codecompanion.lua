-- Dependencies
vim.pack.add({
  'https://github.com/echasnovski/mini.diff',
}, { confirm = false })

-- CodeCompanion
vim.pack.add({
  'https://github.com/olimorris/codecompanion.nvim',
}, { confirm = false })

-- Defer setup until first use
local initialized = false
local function ensure_setup()
  if initialized then
    return
  end
  initialized = true

  local diff = require 'mini.diff'
  diff.setup {
    source = diff.gen_source.none(),
  }

  require('codecompanion').setup {
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
  }
end

-- Keymaps — all trigger ensure_setup() on first use
local mapping_key_prefix = vim.g.ai_prefix_key or '<leader>a'

local function cc_cmd(cmd)
  return function()
    ensure_setup()
    vim.cmd(cmd)
  end
end

local map = vim.keymap.set
map('n', mapping_key_prefix .. 'a', cc_cmd('CodeCompanionActions'), { desc = 'Code Companion - Actions' })
map({ 'n', 'v' }, mapping_key_prefix .. 't', cc_cmd('CodeCompanionChat Toggle'), { desc = 'Code Companion - Toggle' })
map('v', mapping_key_prefix .. 'e', cc_cmd('CodeCompanion /explain'), { desc = 'Code Companion - Explain code' })
map('v', mapping_key_prefix .. 'f', cc_cmd('CodeCompanion /fix'), { desc = 'Code Companion - Fix code' })
map({ 'n', 'v' }, mapping_key_prefix .. 'l', cc_cmd('CodeCompanion /lsp'), { desc = 'Code Companion - Explain LSP' })
map('v', mapping_key_prefix .. 'T', cc_cmd('CodeCompanion /tests'), { desc = 'Code Companion - Generate tests' })
map('n', mapping_key_prefix .. 'm', cc_cmd('CodeCompanion /staged-commit'), { desc = 'Code Companion - Commit msg' })
map('v', mapping_key_prefix .. 'd', cc_cmd('CodeCompanion /inline-doc'), { desc = 'Code Companion - Inline docs' })
map('v', mapping_key_prefix .. 'D', cc_cmd('CodeCompanion /doc'), { desc = 'Code Companion - Docs' })
map('v', mapping_key_prefix .. 'r', cc_cmd('CodeCompanion /refactor'), { desc = 'Code Companion - Refactor' })
map('v', mapping_key_prefix .. 'R', cc_cmd('CodeCompanion /review'), { desc = 'Code Companion - Review' })
map('v', mapping_key_prefix .. 'n', cc_cmd('CodeCompanion /naming'), { desc = 'Code Companion - Better naming' })
