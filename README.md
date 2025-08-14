# Personal Neovim Configuration

This repository contains my personal Neovim configuration intented to be usually deployed in a NixOS environment.
The configuration requires the latest Neovim version (0.12/main) to work properly.

![Neovim](https://drive.usercontent.google.com/download?id=1GwE8kpaO13ND2OEz7rEsu-j0sfvz88dp)

## How to use

Add the following configuration into your default Neovim directory:

```bash
NVIM_CONFIG="~/.config/nvim/"
mkdir -p $NVIM_CONFIG
cp -r lua/ .stylua.toml init.lua $NVIM_CONFIG 
```

### Normal

If you are using a non-NixOS distribution, make sure you uncomment the Mason configuration to get all LSP's on your machine:

```lua ./lua/plugins/lsp.lua
  { 'mason-org/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
  'mason-org/mason-lspconfig.nvim',
  'WhoIsSethDaniel/mason-tool-installer.nvim',
```

```lua ./lua/plugins/lsp.lua
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }
```

``` lua ./lua/plugins/none-ls.lua
  dependencies = {
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    require('mason-null-ls').setup {
      ensure_installed = {
        'prettier', -- ts/js formatter
        'eslint_d', -- ts/js linter
        'shfmt', -- Shell formatter
        'checkmake', -- linter for Makefiles
      },
      automatic_installation = true,
    }
```

### NixOS

If this configuration is deployed on a NixOS machine, make sure that your configuration has the following packages installed:

```nix
  users.users = {
    myusername = {
      packages = (
        with pkgs;
        [
          stylua
          lua-language-server
          haskell-language-server
          sumneko-lua-language-server
          elmPackages.elm-language-server
          rust-analyzer
          pyright
          sshfs
          ripgrep
          checkmake
          astyle
        ]
      );
    };
  };
```

## Plugins

### General Configuration

- [init.lua](./init.lua): Contains lazy installer and sources all other plugins.
- [keymaps.lua](./lua/core/keymaps.lua): Contains general Neovim keymaps. Plugins keymaps are in their own lua file.
- [options.lua](./lua/core/options.lua): Contains general settings for Neovim.

### Themes

- [colortheme.lua](./lua/plugins/colortheme.lua): Sets the default Neovim theme.

### Completion

- [autocompletion.lua](./lua/plugins/autocompletion.lua): Configures the cmp completion framework and LuaSnip snippet engine.

### Editor Plugins and Configurations

- [neotree.lua](./lua/plugins/neotree.lua): Configures the NeoTree file explorer.
- [treesitter.lua](./lua/plugins/treesitter.lua): Configures the TreeSitter syntax highlighter.
- [indent-blankline.lua](./lua/plugins/indent-blankline.lua): Configures the Indent Blankline plugin for displaying indentation levels.
- [avante.lua](./lua/plugins/avante.lua): Configures the Avante plugin for interacting with different models.

### UI Plugins

- [bufferline.lua](./lua/plugins/bufferline.lua): Configures the Bufferline plugin for enhanced buffer/tab display.
- [lualine.lua](./lua/plugins/lualine.lua): Configures the Lualine status line plugin.
- [undo-glow.lua](./lua/plugins/undo-glow.lua): Adds a visual "glow" effect to your Neovim operations.

### LSP

- [lsp.lua](./lua/plugins/lsp.lua): Configures the Neovim LSP client.
- [conform.lua](./lua/plugins/conform.lua): Configures the Conform plugin for automatic code formatting.

### Git

- [gitsigns.lua](./lua/plugins/gitsigns.lua): Configures the GitSigns plugin for displaying Git diff information.

### Utils

- [my-telescope.lua](./lua/plugins/my-telescope.lua): Configures the Telescope plugin for fuzzy finding and picking.
- [misc.lua](./lua/plugins/misc.lua): Configures additional plugins that don't need complex configuration.
- [remote-sshfs.lua](./lua/plugins/remote-sshfs.lua): Adds support for remote development using sshfs.
- [render-markdown.lua](./lua/plugins/render-markdown.lua): Plugin to improve viewing Markdown files in Neovim.
- [toggleterm.lua](./lua/plugins/toggleterm.lua): Configures Terminal plugin.
- [neovim-tips.lua](./lua/plugins/neovim-tips.lua): Displays common useful Neovim tips and allows you to save new ones.

Please refer to the individual `.lua` files for more detailed configuration information.

## Improvements

1. Selectable color themes
2. Personalized mouse menu

## References

This configuration has taken inspiration from the following contributors:

- [dc-tec](https://github.com/dc-tec/nixvim)
- [hendrikmi](https://github.com/hendrikmi/neovim-kickstart-config)
