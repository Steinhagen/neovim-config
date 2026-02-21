local utils = require 'utils.system'

-- Install all LSP-related plugins
vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  -- Mason plugins (Conditional for non-NixOS)
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
}, { confirm = false })

-- Configure Mason (if not on NixOS)
if not utils.is_nixos() then
  require('mason').setup()
  require('mason-lspconfig').setup()
end

-- Configure Fidget (UI status)
require('fidget').setup {
  notification = {
    window = { winblend = 0 },
  },
}

-- LSP Attach Autocommands (Mappings & Highlights)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Document Highlighting
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Inlay Hints
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Broadcast Capabilities to Servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- We use pcall here just in case cmp-nvim-lsp hasn't loaded yet
local status, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if status then
  capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
end

-- Server Configurations
local gcc_path = vim.fn.exepath 'gcc'
local servers = {
  ansiblels = {},
  bashls = {},
  clangd = {
    cmd = { 'clangd', '--background-index', '--pch-storage=memory', '--query-driver=' .. gcc_path },
  },
  cmake = {},
  cssls = {},
  dockerls = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file('', true),
        },
        diagnostics = {
          globals = { 'vim', 'Snacks' },
          disable = { 'missing-fields' },
        },
        format = { enable = false },
      },
    },
  },
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          autopep8 = { enabled = false },
          mccabe = { enabled = false },
          pycodestyle = { enabled = false },
          pyflakes = { enabled = false },
          pylsp_black = { enabled = false },
          pylsp_isort = { enabled = false },
          pylsp_mypy = { enabled = false },
          yapf = { enabled = false },
        },
      },
    },
  },
  puppet_editor_services = {},
  ruff = {},
  tailwindcss = {},
  terraformls = {},
  ts_ls = {},
  tinymist = {},
  yamlls = {},
}

-- Install Tools & Enable Servers

if not utils.is_nixos() then
  -- Create a clean list of package names for Mason
  local ensure_installed = {}
  -- Add all servers, but fix the ones where LSP name != Mason name
  for server, _ in pairs(servers) do
    if server == 'puppet_editor_services' then
      table.insert(ensure_installed, 'puppet-editor-services') -- Use dash for Mason
    elseif server == 'ts_ls' then
      table.insert(ensure_installed, 'typescript-language-server') -- Use full name for Mason
    else
      table.insert(ensure_installed, server)
    end
  end
  vim.list_extend(ensure_installed, { 'stylua' })
  require('mason-tool-installer').setup {
    ensure_installed = ensure_installed,
    auto_update = false,
    run_on_start = true,
  }
end

for server, cfg in pairs(servers) do
  cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, cfg.capabilities or {})
  vim.lsp.config(server, cfg)
  vim.lsp.enable(server)
end

-- Global LSP Keymaps
vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>', { desc = 'LSP: server restart' })
vim.keymap.set('n', '<leader>ll', ':LspLog<CR>', { desc = 'LSP: server log' })
