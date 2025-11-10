return {
  'gisketch/triforce.nvim',
  dependencies = {
    'nvzone/volt',
  },
  config = function()
    require('triforce').setup {
      enabled = true, -- Enable/disable the entire plugin
      gamification_enabled = true, -- Enable XP, levels, achievements

      -- Notification settings
      notifications = {
        enabled = true, -- Master toggle for all notifications
        level_up = true, -- Show level up notifications
        achievements = true, -- Show achievement unlock notifications
      },

      -- Keymap configuration
      keymap = {
        show_profile = '<leader>tp', -- Set to nil to disable default keymap
      },

      -- Auto-save interval (in seconds)
      auto_save_interval = 300, -- Save stats every 5 minutes
    }
  end,
}
