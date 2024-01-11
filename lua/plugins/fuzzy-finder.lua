return {
	-- https://github.com/nvim-telescope/telescope.nvim
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = true,
		keys = {
			{ '<C-p>', function()
				-- fallback to find all files if cwd is not a git directory
				local _, ret, _ = require('telescope.utils').get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' })
				if ret == 0 then
					require('telescope.builtin').git_files()
				else
					require('telescope.builtin').find_files()
				end
			end },
			{ '<leader>f', function() require('telescope.builtin').grep_string({ search = vim.fn.input('Grep > ') }) end },
		}
	}
}
