return {
    -- https://github.com/stevearc/conform.nvim
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "=",
                function() require("conform").format({ async = true }) end,
                mode = { "n", "v" },
                desc = "Format buffer or selection",
            },
        },
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            formatters_by_ft = {
                javascript = { "prettierd", "prettier", stop_after_first = true },
                lua = { "stylua" },
                python = { "ruff_organize_imports", "ruff_format" },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
            },
            default_format_opts = {
                lsp_format = "fallback", -- use the language server when no formatter is listed
            },
            format_on_save = { timeout_ms = 500 },
        },
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
    -- https://github.com/nvim-treesitter/nvim-treesitter
    -- `main` branch: needs Neovim 0.12+, the `tree-sitter` CLI and a C compiler
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false, -- does not support lazy-loading
        build = ":TSUpdate",
        config = function()
            -- c, lua, vim, vimdoc, query and markdown parsers ship with Neovim
            -- Reference: https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
            require("nvim-treesitter").install({
                "go",
                "gomod",
                "gosum",
                "gowork",
                "html",
                "javascript",
                "json",
                "kotlin",
                "tsx",
                "typescript",
                "yaml",
            })

            -- highlighting is built into Neovim; start it for every filetype that has a parser
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
    -- https://github.com/windwp/nvim-ts-autotag
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },
}
