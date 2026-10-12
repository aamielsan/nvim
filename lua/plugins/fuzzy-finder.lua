-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
-- uses ripgrep for grep and fd for files
return {
    {
        "folke/snacks.nvim",
        opts = {
            picker = {
                sources = {
                    buffers = {
                        win = {
                            input = {
                                keys = {
                                    ["<Leader>q"] = { "bufdelete", mode = { "n", "i" } },
                                },
                            },
                        },
                    },
                },
            },
        },
        keys = {
            { "<Leader>f", function() Snacks.picker.grep() end, desc = "Grep" },
            { "<Leader>p", function() Snacks.picker.files() end, desc = "Find files" },
            { "<Leader>o", function() Snacks.picker.buffers() end, desc = "Buffers" },
        },
    },
}
