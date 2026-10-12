-- pick the theme matching the terminal's light/dark background, which Neovim detects on startup
local function apply_theme()
    local theme = vim.o.background == "dark" and "github_dark_dimmed" or "github_light_tritanopia"
    if vim.g.colors_name ~= theme then
        vim.cmd.colorscheme(theme)
    end
end

local function github()
    return {
        "projekt0n/github-nvim-theme",
        lazy = false,
        priority = 1000,
        config = function()
            apply_theme()
            vim.api.nvim_create_autocmd("OptionSet", { pattern = "background", callback = apply_theme })
        end,
    }
end

return {
    github(),
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    globalstatus = true,
                },
                sections = {
                    lualine_a = {"mode"},
                    lualine_b = {"branch", "diff", "diagnostics"},
                    lualine_c = {{"filename", path=3}},
                    lualine_x = {"encoding", "filetype", "lsp_status"},
                    lualine_y = {"progress"},
                    lualine_z = {"location"}
                },
            })
        end
    },
}
