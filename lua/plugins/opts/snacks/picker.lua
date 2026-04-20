return {
  sources = {
    explorer = {
      hidden = true,
      ignored = true,
      actions = {
        set_tab_cwd = function(picker, item)
          if not item then
            return
          end

          -- Safely get the path of the hovered item
          local path = item.file or picker:cwd()
          local dir = vim.fn.isdirectory(path) == 1 and path or vim.fn.fnamemodify(path, ':h')

          -- Change the tab directory and update the picker
          vim.cmd('tcd ' .. vim.fn.fnameescape(dir))

          -- This forces the explorer to cleanly wipe its existing data before redrawing.
          picker:update({ cwd = dir })
        end,

        set_tab_cwd_up = function(picker)
          -- Grab the current root directory of the explorer
          local current_cwd = picker:cwd()

          -- Get the parent directory
          local parent_dir = vim.fn.fnamemodify(current_cwd, ":h")

          -- Change Neovim's tab working directory
          vim.cmd('tcd ' .. vim.fn.fnameescape(parent_dir))

          -- Force the explorer to wipe its data and redraw using the parent
          picker:update({ cwd = parent_dir })
        end,

      },
      win = {
        list = {
          keys = {
            ['<C-t>'] = false, -- disable terminal shortcut in Snacks explorer
            ['.'] = 'set_tab_cwd', -- Map '.' to go into a directory
            ['<bs>'] = 'set_tab_cwd_up', -- Map backspace to go up to the parent directory
          },
          wo = {
            number = true,
            relativenumber = true,
          },
        },
      },
    },
    files = {
      hidden = true,
      ignored = true,
      win = {
        list = {
          wo = {
            number = true,
            relativenumber = true,
          },
        },
      },
    },
    grep = {
      hidden = true,
      ignored = true,
      win = {
        list = {
          wo = {
            number = true,
            relativenumber = true,
          },
        },
      },
    },
  },
}
