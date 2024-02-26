local function melange()
    return {
        "savq/melange-nvim",
        config = function()
            vim.cmd("colorscheme melange")
        end,
    }
end

return {
    melange(),
    {
        "nvim-lualine/lualine.nvim",
        vent = "BufReadPre",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    sections = {
                        lualine_a = {"mode"},
                        lualine_b = {"branch", "diff", "diagnostics"},
                        lualine_c = {"filename"},
                        lualine_x = {"encoding", "fileformat", "filetype"},
                        lualine_y = {"progress"},
                        lualine_z = {"location"}
                    },
                }
            })
        end
    },
}
