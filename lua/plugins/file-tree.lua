return {
	{
		'nvim-tree/nvim-tree.lua',
		tag = 'v0.99',
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		config = true,
		keys = {
			{ '<C-t>', vim.cmd.NvimTreeToggle }
		}
	},
	{
		'nvim-tree/nvim-web-devicons',
		branch = 'master'
	}
}
