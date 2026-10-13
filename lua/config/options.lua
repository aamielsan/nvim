vim.g.mapleader = " "

-- no plugins use the language providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

local opt = vim.opt

opt.clipboard = "unnamedplus" -- use system clipboard

-- ui
opt.termguicolors = true -- true color support
opt.cursorline = true -- highlight current line
opt.wrap = false -- nowrap
opt.winborder = "rounded" -- borders on all floating windows

-- line numbers
opt.number = true -- show line numbers
opt.relativenumber = true -- show relative line numbers

-- indents
opt.smartindent = true
opt.autoindent = true

opt.shiftround = true -- round-off indents to align
-- opt.foldmethod = "indent"

-- backups
opt.swapfile = false
opt.backup = false

-- undo history
opt.undofile = true

-- search
opt.hlsearch = true
opt.incsearch = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 250

-- auto-reload files when changed externally
opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})
