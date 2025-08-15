return {
  'yetone/avante.nvim',
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true` must add this setting!
  build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'echasnovski/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'stevearc/dressing.nvim', -- for input provider dressing
    'folke/snacks.nvim', -- for input provider snacks
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
  config = function()
    require('avante').setup {
      -- "claude" | "openai" | "azure" | "gemini" | "ollama" | "copilot" | "moonshot" | "perplexity"
      provider = 'gemini',
      providers = {
        perplexity = {
          __inherited_from = 'openai',
          api_key_name = 'PERPLEXITY_API_KEY',
          endpoint = 'https://api.perplexity.ai',
          model = 'llama-3.1-sonar-large-128k-online',
        },
        ollama = {
          endpoint = 'http://127.0.0.1:11434',
          model = 'qwen3-coder:30b', -- 'qwen3:8b',
          -- Workaround: https://github.com/yetone/avante.nvim/issues/2557
          is_env_set = function()
            return true
          end,
        },
      },
    }

    local function set_avante_highlights()
      local utils = require 'core.utils'
      -- Theme highlights correctly
      vim.api.nvim_set_hl(0, 'AvanteTitle', { fg = utils.title_fg, bg = utils.normal_bg, bold = true })
      vim.api.nvim_set_hl(0, 'AvanteReversedTitle', { fg = utils.normal_bg, bg = utils.normal_bg })
      vim.api.nvim_set_hl(0, 'AvanteSubtitle', { fg = utils.select_fg, bg = utils.normal_bg, bold = true })
      vim.api.nvim_set_hl(0, 'AvanteReversedSubtitle', { fg = utils.normal_bg, bg = utils.normal_bg })
      vim.api.nvim_set_hl(0, 'AvanteThirdTitle', { fg = utils.ask_fg, bg = utils.normal_bg, bold = true })
      vim.api.nvim_set_hl(0, 'AvanteReversedThirdTitle', { fg = utils.normal_bg, bg = utils.normal_bg })
    end

    -- Apply highlights immediately and on theme change
    set_avante_highlights()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = set_avante_highlights,
    })
  end,
}
