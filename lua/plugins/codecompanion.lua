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

  -- CodeCompanion reads the YAML frontmatter of its prompt library with
  -- treesitter, so the `yaml` parser must exist before setup() runs.
  -- treesitter.lua installs parsers lazily from a FileType autocmd, which may
  -- not have fired yet (or ever, on a fresh machine). `force` because
  -- install() otherwise trusts the parser-info revision marker and skips even
  -- when the compiled parser is gone.
  if #vim.api.nvim_get_runtime_file('parser/yaml.so', false) == 0 then
    vim.notify('Installing the yaml treesitter parser for CodeCompanion…', vim.log.levels.INFO)
    pcall(function()
      require('nvim-treesitter').install({ 'yaml' }, { force = true }):wait(120000)
    end)
  end

  local diff = require 'mini.diff'
  diff.setup {
    source = diff.gen_source.none(),
  }

  require('codecompanion').setup {
    strategies = {
      chat = { adapter = 'llama_cpp' },  -- 'gemini' / 'kiro' / 'opencode'
      inline = { adapter = 'llama_cpp' },  -- 'deepseek'
    },

    adapters = {
      acp = {
        opencode = function()
          return require("codecompanion.adapters").extend("opencode", {
            defaults = {
              session_config_options = {
                model = "deepseek/deepseek-v4-pro",
              },
            },
          })
        end,
      },
      http = {
        -- Local llama-server (services.llama-cpp on middle-ring, loopback only).
        -- CodeCompanion has no llama.cpp adapter, so this extends the generic
        -- OpenAI-compatible one at llama-server's /v1 endpoint.
        llama_cpp = function()
          return require('codecompanion.adapters').extend('openai_compatible', {
            env = {
              url = 'http://127.0.0.1:8012',
              chat_url = '/v1/chat/completions',
              models_endpoint = '/v1/models',
              -- llama-server is started without --api-key, but the adapter
              -- always sends an Authorization header, so it needs a value.
              -- Not an env var name, so it is used literally.
              api_key = 'sk-local',
            },
            handlers = {
              -- llama-server runs with --jinja, so the model's own chat
              -- template applies. Qwen3.5's raises
              --   "System message must be at the beginning"
              -- for anything other than exactly one system message in first
              -- position, and a chat buffer routinely has several (default
              -- system prompt + tool prompts). Consolidate them the way the
              -- bundled deepseek adapter does; openai_compatible does not.
              form_messages = function(self, messages)
                local utils = require 'codecompanion.adapters.utils'
                local openai = require 'codecompanion.adapters.http.openai'
                return openai.handlers.form_messages(self, utils.merge_system_messages(messages))
              end,
            },
            schema = {
              model = {
                -- Matches --alias in shared/llama-cpp.nix; /v1/models reports
                -- exactly this id.
                default = 'qwen3.5-9b-llamacpp',
              },
            },
          })
        end,

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

        deepseek = function()
          return require("codecompanion.adapters").extend("deepseek", {
            schema = {
              model = {
                default = "deepseek-v4-pro",
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
                default = 'gemini-3.5-flash',
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
