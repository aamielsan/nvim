return {
    -- https://github.com/stevearc/conform.nvim
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "=", -- The key you want
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = { "n", "v" }, -- Works in both Normal and Visual mode
                desc = "Format buffer or selection",
            },
        },
        -- This will provide type hinting with LuaLS
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            -- Define your formatters
            formatters_by_ft = {
                javascript = { "prettierd", "prettier", stop_after_first = true },
                lua = { "stylua" },
                python = { "ruff_organize_imports", "ruff_format" },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
            },
            -- Set default options
            default_format_opts = {
                lsp_format = "fallback",
            },
            -- Set up format-on-save
            format_on_save = { timeout_ms = 500 },
            -- Customize formatters
            formatters = {
                shfmt = {
                    append_args = { "-i", "2" },
                },
            },
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
                "rust",
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
