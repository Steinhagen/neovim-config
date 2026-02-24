return {
  sources = {
    explorer = {
      win = {
        list = {
          keys = {
            ['<C-t>'] = false, -- disable terminal shortcut in Snacks explorer
          },
          wo = {
            number = true,
            relativenumber = true,
          },
        },
      },
    },
    files = {
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
