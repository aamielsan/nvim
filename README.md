# nvim

Contains Neovim configuration using Lua as the configuration language.

## Getting started
1. Install the dependencies. The [dotfiles](https://github.com/aamielsan/dotfiles) mise config installs all of them:
   - `neovim` 0.12+
   - `ripgrep` and `fd` for the pickers (`snacks.nvim`)
   - `tree-sitter` CLI and a C compiler (Xcode Command Line Tools) to build parsers (`nvim-treesitter`)
   - `node`, `go` and `python` so Mason can install the language servers and formatters
2. Clone repository to `~/.config/nvim/` (the dotfiles bootstrap does this)
3. Start `nvim`: `lazy.nvim` installs the plugins, and Mason installs the language servers and formatters

## Useful commands
1. `:Lazy`: opens the window for the plugin manager (`lazy.nvim`). Update plugins with `:Lazy update`; there is no automatic update check.
2. `:Mason`: opens the window for the package manager for LSP servers, DAP servers, linters, and formatters (`mason.nvim`).

## Folder structure

### [lua/config/keymaps.lua](lua/config/keymaps.lua)
- Define your custom keymaps here using the [vim.keymap](https://neovim.io/doc/user/lua.html#vim.keymap) module.
- Since the keymaps are binded after the plugins are loaded, then it can use functions exported by plugins.

### [lua/config/options.lua](lua/config/options.lua)
- Define your custom neovim options here using [vim.opt](https://neovim.io/doc/user/lua.html#vim.opt).

### [lua/config/package-manager.lua](lua/config/package-manager.lua)
- Out of the box configuration for the package manager.

### [lua/plugins/*.lua](lua/plugins/)
- Plugin directory which contains the plugins to download, with the plugin's configurations.
- Each module in the directory should return a Lua table that contains the plugin/s to download using `lazy.nvim`.
  See [lazy.nvim startup sequence](https://github.com/folke/lazy.nvim?tab=readme-ov-file#%EF%B8%8F-startup-sequence)
