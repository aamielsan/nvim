return {
    -- https://github.com/tpope/vim-sleuth
    { "tpope/vim-sleuth" },
    -- https://github.com/windwp/nvim-autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    -- https://github.com/kylechui/nvim-surround
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = true
    },
    -- https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md
    {
        "folke/snacks.nvim",
        opts = {
            terminal = {},
        },
        keys = {
            { "<leader>tf", function() Snacks.terminal.toggle(nil, { win = { position = "float", border = "rounded", width = 0.8, height = 0.9 } }) end, desc = "Terminal Float" },
            { "<leader>th", function() Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 15 } }) end, desc = "Terminal Horizontal" },
            { "<leader>tv", function() Snacks.terminal.toggle(nil, { win = { position = "right", width = 0.4 } }) end, desc = "Terminal Vertical" },
        },
    },
}
