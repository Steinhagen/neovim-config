# Personal Neovim Configuration

This repository contains my personal Neovim configuration intented to be usually deployed in a NixOS environment.

![Neovim](https://drive.usercontent.google.com/download?id=1hpo7051qy3cDHnQPI-4V28TpBi8qiyVg)

## Requirements

1. Neovim version 0.12 or later.
2. Ghostty or Kitty terminal for image protocol support.
3. python3-venv for some Mason packages.
4. tmux with image support enabled. To do that make sure you have the following configuration enabled:

```tmux
set -g default-terminal "tmux-256color"
set -g allow-passthrough on
set -ga update-environment TERM
set -ga update-environment TERM_PROGRAM
```

## How to use

Add the following configuration into your default Neovim directory:

```bash
NVIM_CONFIG="~/.config/nvim/"
mkdir -p $NVIM_CONFIG
cp -r lua/ .stylua.toml init.lua $NVIM_CONFIG
```

## Installation

If you are using a non-NixOS distribution, the Mason configuration should be enabled automatically so that you get all LSP's on your machine.

 Debian:
```bash
echo "Install all needed packages..."
sudo apt install -y cmake nodejs npm python3 python3-pip clang
```

 Fedora:
```bash
echo "Install all needed packages..."
sudo dnf install -y cmake nodejs npm python3 python3-pip clang
```

Common for non  NixOS distributions:
```bash
echo "1. Making sure we have the latest nvim version installed..."
TEMP_DIR=$(mktemp -d)
git clone --single-branch --branch master https://github.com/neovim/neovim.git "$TEMP_DIR"
cd "$TEMP_DIR" && make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install && cd -

echo "2. Cleaning nvim data and config directories..."
rm -rf "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim" "$HOME/.config/nvim"

echo "3. Get the latest personal nvim configuration..."
git clone https://github.com/Steinhagen/neovim-config $HOME/.config/nvim
```

Since Mason doesn't work for NixOS, we need to provide all LSPs that we are using ourselves.

 NixOS
```nix
packages = (
  with pkgs;
  [
    # Application packages
    ghostty
    opencode
    imagemagick
    typst
    fzf

    # Language servers
    rust-analyzer
    pyright
    sshfs
    ripgrep
    checkmake
    astyle
    lua-language-server
    haskell-language-server
    sumneko-lua-language-server
    elmPackages.elm-language-server
    ansible-language-server
    bash-language-server
    vscode-langservers-extracted
    dockerfile-language-server-nodejs
    python3Packages.python-lsp-server
    ruff
    tailwindcss-language-server
    terraform-ls
    typescript-language-server
    yaml-language-server
  ]
);
```

## Theme

Neovim will automatically detect what theme you are currently using (dark/light) and will adapt to it.
If you want to force a specific environment theme, set the variable `NVIM_THEME_MODE` to `light` or `dark`:

``` bash
export NVIM_THEME_MODE="light"
```

## Plugins

### General Configuration

- [init.lua](./init.lua): Contains lazy installer and sources all other plugins.
- [keymaps.lua](./lua/core/keymaps.lua): Contains general Neovim keymaps. Plugins keymaps are in their own lua file.
- [options.lua](./lua/core/options.lua): Contains general settings for Neovim.
- [menu.lua](./lua/core/menu.lua): Contains the right-click menu settings.
- [utils.lua](./lua/core/utils.lua): Contains common functions that are used in plugins.

### Themes

- **folke/tokyonight.nvim** [colortheme.lua](./lua/plugins/colortheme.lua): Sets the default Neovim theme.

### Completion

- **hrsh7th/nvim-cmp** [autocompletion.lua](./lua/plugins/autocompletion.lua): Configures the cmp completion framework and LuaSnip snippet engine.

### Editor Plugins and Configurations

- **nvim-neo-tree/neo-tree.nvim** [neotree.lua](./lua/plugins/neotree.lua): Configures the NeoTree file explorer.
- **nvim-treesitter/nvim-treesitter** [treesitter.lua](./lua/plugins/treesitter.lua): Configures the TreeSitter syntax highlighter.
- **lukas-reineke/indent-blankline.nvim** [indent-blankline.lua](./lua/plugins/indent-blankline.lua): Configures the Indent Blankline plugin for displaying indentation levels.
- **olimorris/codecompanion.nvim** [avante.lua](./lua/plugins/olimorris/codecompanion.lua): Configures the Code Companion plugin for interacting with different AI models.
- **windwp/nvim-autopairs** [misc.lua](./lua/plugins/misc.lua): Autoclose parentheses, brackets, quotes, etc.

### UI Plugins

- **akinsho/bufferline.nvim** [bufferline.lua](./lua/plugins/bufferline.lua): Configures the Bufferline plugin for enhanced buffer/tab display.
- **nvim-lualine/lualine.nvim** [lualine.lua](./lua/plugins/lualine.lua): Configures the Lualine status line plugin.
- **y3owk1n/undo-glow.nvim** [undo-glow.lua](./lua/plugins/undo-glow.lua): Adds a visual "glow" effect to your Neovim operations.
- **3rd/image.nvim** [image.lua](./lua/plugins/image.lua): Render images directly inside the terminal.
- **folke/which-key.nvim** [misc.lua](./lua/plugins/misc.lua): Hints keybinds.

### LSP

- **neovim/nvim-lspconfig** [lsp.lua](./lua/plugins/lsp.lua): Configures the Neovim LSP client.
- **stevearc/conform.nvim** [conform.lua](./lua/plugins/conform.lua): Configures the Conform plugin for automatic code formatting.
- **nvimtools/none-ls.nvim** [none-ls.lua](./lua/plugins/none-ls.lua): Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.

### Git

- **lewis6991/gitsigns.nvim** [gitsigns.lua](./lua/plugins/gitsigns.lua): Configures the GitSigns plugin for displaying Git diff information.
- **tpope/vim-fugitive** [misc.lua](./lua/plugins/misc.lua): Powerful Git integration for Vim.
- **tpope/vim-rhubarb** [misc.lua](./lua/plugins/misc.lua): GitHub integration for vim-fugitive.

### Utils

- **nvim-telescope/telescope.nvim** [my-telescope.lua](./lua/plugins/my-telescope.lua): Configures the Telescope plugin for fuzzy finding and picking.
- **nosduco/remote-sshfs.nvim** [remote-sshfs.lua](./lua/plugins/remote-sshfs.lua): Adds support for remote development using SSHFS.
- **amitds1997/remote-nvim.nvim** [remote-nvim.lua](./lua/plugins/remote-nvim.lua): Adds support for remote development similar to VSCode.
- **MeanderingProgrammer/render-markdown.nvim** [render-markdown.lua](./lua/plugins/render-markdown.lua): Plugin to improve viewing Markdown files in Neovim.
- **akinsho/toogleterm.nvim** [toggleterm.lua](./lua/plugins/toggleterm.lua): Configures Terminal plugin.
- **saxon1964/neovim-tips** [neovim-tips.lua](./lua/plugins/neovim-tips.lua): Displays common useful Neovim tips and allows you to save new ones.
- **christoomey/vim-tmux-navigator** [misc.lua](./lua/plugins/misc.lua): Tmux & split window navigation.

Please refer to the individual `.lua` files for more detailed configuration information.

## Improvements

1. Improve mouse menu

## References

This configuration has taken inspiration from the following contributors:

- [dc-tec](https://github.com/dc-tec/nixvim)
- [hendrikmi](https://github.com/hendrikmi/neovim-kickstart-config)
