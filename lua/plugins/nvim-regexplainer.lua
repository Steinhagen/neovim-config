vim.pack.add({
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/bennypowers/nvim-regexplainer"
}, { confirm = false })

vim.api.nvim_create_autocmd("BufRead", {
  callback = function()
    require('regexplainer').setup({
      auto = true,
      display = 'popup',
      popup = {
        border = {
          padding = { 0, 0 },
          style = 'rounded',
        },
      },
    })
  end,
  once = true, -- this ensures the setup only runs the very first time you read a buffer
})
