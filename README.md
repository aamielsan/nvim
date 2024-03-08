# nvim

Contains Neovim configuration using Lua as the configuration language.

## Getting started
1. Install [neovim.io](https://neovim.io/)
2. Install `ripgrep` for fuzzy finder (`telescope.nvim`)
3. Clone repository to `~/.config/nvim/`

## Useful commands
1. `:Lazy`: opens the window for the plugin manager (`lazy.nvim`).
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
