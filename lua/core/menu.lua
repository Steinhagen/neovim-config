vim.cmd [[
  aunmenu PopUp
  anoremenu PopUp.Inspect           <cmd>Inspect<CR>
  amenu PopUp.-1-                   <NOP>
  anoremenu PopUp.Definition        <cmd>lua vim.lsp.buf.definition()<CR>
  anoremenu PopUp.References        <cmd>lua vim.lsp.buf.references()<CR>
  anoremenu PopUp.Implementation    <cmd>lua vim.lsp.buf.implementation()<CR>
  amenu PopUp.-2-                   <NOP>
  anoremenu PopUp.Split\ Vertical   <cmd>vsplit<CR>
  anoremenu PopUp.Split\ Horizontal <cmd>split<CR>
  anoremenu PopUp.Close\ Pane       <cmd>close<CR>
  amenu PopUp.-3-                   <NOP>
  anoremenu PopUp.Toggle\ Explorer  <cmd>lua Snacks.explorer()<CR>
  anoremenu PopUp.Buffers           <cmd>lua Snacks.picker.buffers()<CR>
  amenu PopUp.-4-                   <NOP>
  nnoremenu PopUp.Back              <C-t>
]]

local group = vim.api.nvim_create_augroup('nvim.popupmenu', { clear = true })
vim.api.nvim_create_autocmd('MenuPopup', {
  pattern = '*',
  group = group,
  desc = 'Right-Click Mouse Setup',
  callback = function()
    vim.cmd [[
      amenu disable PopUp.Definition
      amenu disable PopUp.References
      amenu disable PopUp.Implementation
    ]]

    if vim.lsp.get_clients({ bufnr = 0 })[1] then
      vim.cmd [[
        amenu enable PopUp.Definition
        amenu enable PopUp.References
        amenu enable PopUp.Implementation
      ]]
    end
  end,
})
