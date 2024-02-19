-- https://github.com/nvim-telescope/telescope.nvim
return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        -- also depends on ripgrep: `brew install ripgrep`
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = true,
        keys = {
            { '<Leader>f', function() require('telescope.builtin').live_grep({}) end },
            { '<Leader>p', function() require('telescope.builtin').find_files() end },
        }
    }
}
