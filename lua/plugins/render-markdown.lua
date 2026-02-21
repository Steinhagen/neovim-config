vim.pack.add({
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim"
}, { confirm = false })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "codecompanion" },
  callback = function()
    require('render-markdown').setup({
      render_modes = { 'n', 'c', 't' },
    })
  end,
  once = true, -- ensure this setup only runs the first time one of these filetypes is opened
})
