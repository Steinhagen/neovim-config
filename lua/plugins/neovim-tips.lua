return {
  "saxon1964/neovim-tips",
  lazy = true, -- Load only when keybinds are triggered
  dependencies = {
    "MunifTanjim/nui.nvim",
    "MeanderingProgrammer/render-markdown.nvim", -- Clean rendering
    -- "OXY2DEV/markview.nvim", -- Rich rendering with advanced features
  },
  opts = {
    user_file = vim.fn.stdpath 'config' .. '/lua/plugins/data/neovim-tips/user-tips.txt',
    -- Daily tip DOES NOT WORK with lazy = true
    daily_tip = 0, -- 0 = off, 1 = once per day, 2 = every startup
    quiet = true,
    bookmark_symbol = "🌟 ",
  },
  keys = {
    { "<leader>nto", ":NeovimTips<CR>", desc = "Neovim tips" },
    { "<leader>ntb", ":NeovimTipsBookmarks<CR>", desc = "Bookmarked tips" },
    { "<leader>ntr", ":NeovimTipsRandom<CR>", desc = "Show random tip" },
    { "<leader>nte", ":NeovimTipsEdit<CR>", desc = "Edit your tips" },
    { "<leader>nta", ":NeovimTipsAdd<CR>", desc = "Add your tip" },
    { "<leader>ntp", ":NeovimTipsPdf<CR>", desc = "Open tips PDF" },
  },
}
