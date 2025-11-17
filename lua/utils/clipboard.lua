local opt = vim.opt
local M = {}

local function paste()
  return {
    vim.split(vim.fn.getreg '', '\n'),
    vim.fn.getregtype '',
  }
end

function M.init()
  if vim.env.SSH_TTY then
    opt.clipboard:append 'unnamedplus'
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy '+',
        ['*'] = require('vim.ui.clipboard.osc52').copy '*',
      },
      paste = {
        ['+'] = paste,
        ['*'] = paste,
      },
    }
  else
    opt.clipboard:append 'unnamedplus'
  end
end

return M
