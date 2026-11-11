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
      require('nvim-treesitter').install({ 'yaml' }, { force = true }):wait(15000)
    end)
  end

  local diff = require 'mini.diff'
  diff.setup {
    source = diff.gen_source.none(),
  }

  require('codecompanion').setup {
    strategies = {
      -- Default chat is OpenCode on its free DeepSeek V4.1 Flash model. DSH is
      -- one keymap away (<leader>aH) and can be made the default by swapping
      -- this name back to 'dsh'. Override per invocation with
      -- :CodeCompanionChat adapter=gemini (or dsh / llama_cpp / kiro).
      chat = { adapter = 'opencode' },  -- 'opencode' / 'dsh' / 'llama_cpp' / 'gemini' / 'kiro'
      -- inline stays on an HTTP adapter: CodeCompanion's inline-ACP driver
      -- applies edits by diffing a temp copy of the buffer and only auto-approves
      -- read/search/think/fetch/edit-of-that-copy tool calls. DSH reports every
      -- tool as kind='other' with no locations or diffs, so inline would reject
      -- each one and nothing would ever be edited.
      -- inline = { adapter = 'gemini' },  -- 'llama_cpp' / 'deepseek' / 'gemini'
    },

    adapters = {
      acp = {
        -- DeepSeek Harness speaks the Agent Client Protocol over stdio
        -- (`dsh acp` == `dsh --profile acp`), so CodeCompanion can drive it as
        -- a normal ACP agent. DSH owns tool execution and file writes itself,
        -- so it does not use ACP's fs/terminal delegation: CodeCompanion is
        -- just the chat surface, permission prompts come back as
        -- session/request_permission, and edits are made by DSH's own tools.
        dsh = function()
          return require('codecompanion.adapters').extend('opencode', {
            name = 'dsh',
            formatted_name = 'DeepSeek Harness',
            commands = {
              default = { 'dsh', 'acp' },
            },
            -- session/new advertises image prompts as false for this profile.
            opts = { vision = false },
            defaults = {
              timeout = 30000, -- handshake only; prompts stream without one
              session_config_options = {
                -- Resolved against the values/names advertised by session/new
                -- configOptions; the /model picker lists the same set.
                model = 'DeepSeek-V4-Pro',
                -- DSH reports reasoning effort under the `thought_level`
                -- category (off/low/high/max).
                thought_level = 'high',
              },
            },
          })
        end,

        opencode = function()
          return require("codecompanion.adapters").extend("opencode", {
            defaults = {
              session_config_options = {
                -- OpenCode's free tier. Gated to the OpenCode client (Zen's HTTP
                -- API answers FreeUsageLimitError for anyone else), which is why
                -- this model can only be reached through this adapter, not DSH.
                model = "opencode/deepseek-v4.1-flash-free",
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

-- DeepSeek Harness chat (ACP). Unlike the HTTP adapters, DSH runs its own
-- tools: it reads and edits files in the working directory, so this window is
-- only the conversation — no system prompt, no #buffer stuffing required.
-- A visual selection becomes the chat's context (chat() reads the live visual
-- range, which the `'<`/`'>` marks do not have yet inside a mapping).
map({ 'n', 'v' }, mapping_key_prefix .. 'H', function()
  ensure_setup()
  if vim.fn.executable 'dsh' == 0 then
    return vim.notify('dsh is not on PATH', vim.log.levels.ERROR)
  end
  require('codecompanion').chat { params = { adapter = 'dsh' } }
end, { desc = 'Code Companion - DeepSeek Harness chat' })
