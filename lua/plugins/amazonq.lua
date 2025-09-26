local mapping_key_prefix = vim.g.ai_prefix_key or '<leader>a'

return {
  'awslabs/amazonq.nvim',
  cmd = 'AmazonQ',
  keys = {
    { mapping_key_prefix .. 'c', '<CMD>AmazonQ context<CR>', desc = 'Context' },
    { mapping_key_prefix .. 'e', '<CMD>AmazonQ explain<CR>', desc = 'Explain', mode = { 'n', 'v' } },
    { mapping_key_prefix .. 'f', '<CMD>AmazonQ fix<CR>', desc = 'Fix code', mode = { 'n', 'v' } },
    { mapping_key_prefix .. 'h', '<CMD>AmazonQ help<CR>', desc = 'Help' },
    { mapping_key_prefix .. 'l', '<CMD>AmazonQ login<CR>', desc = 'Login' },
    { mapping_key_prefix .. 'L', '<CMD>AmazonQ logout<CR>', desc = 'Logout' },
    { mapping_key_prefix .. 'o', '<CMD>AmazonQ optimize<CR>', desc = 'Optimize', mode = { 'n', 'v' } },
    { mapping_key_prefix .. 'r', '<CMD>AmazonQ refactor<CR>', desc = 'Refactor', mode = { 'n', 'v' } },
    { mapping_key_prefix .. 't', '<CMD>AmazonQ toggle<CR>', desc = 'Toggle' },
    { mapping_key_prefix .. 'q', '<CMD>AmazonQ<CR>', desc = 'AmazonQ', mode = { 'n', 'v' } },
    { mapping_key_prefix .. 'x', '<CMD>AmazonQ clear<CR>', desc = 'Clear' },
  },
  config = function()
    local ssoStartUrl = vim.env.AMAZONQ_SSO_START_URL or 'https://view.awsapps.com/start'

    require('amazonq').setup {
      ssoStartUrl = ssoStartUrl,
      inline_suggestion = false,
      on_chat_open = function()
        vim.cmd 'vertical botright split'
        vim.cmd 'set wrap breakindent nonumber norelativenumber nolist'
      end,
    }
  end,
}
