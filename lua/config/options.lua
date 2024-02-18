vim.g.mapleader = " "

local opt = vim.opt

opt.clipboard = "unnamedplus" -- use system clipboard

-- ui
opt.termguicolors = true -- true color support
opt.cursorline = true -- highlight current line
opt.wrap = false -- nowrap

-- line numbers
opt.number = true -- show line numbers
opt.relativenumber = true -- show relative line numbers

-- indents
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.smartindent = true
opt.autoindent = true

opt.shiftround = true -- round-off indents to align
-- opt.foldmethod = "indent"

-- backups
opt.swapfile = false
opt.backup = false

-- undo history
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- search
opt.hlsearch = true
opt.incsearch = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 50
