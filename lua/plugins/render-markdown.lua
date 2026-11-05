vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "codecompanion" },
  callback = function()
    require('render-markdown').setup({
      render_modes = { 'n', 'c', 't' },
    })
  end,
  once = true, -- ensure this setup only runs the first time one of these filetypes is opened
})
