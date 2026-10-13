local arr = require("internal.array")
local lang = require("internal.language-server")

-- https://github.com/mason-org/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
local lsp_servers = {
    lang.server("dockerls"),
    lang.server("eslint"),
    lang.server("gopls", {
        -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#configuration
        settings = {
            gopls = {
                -- gofumpt = true,
                analyses = {
                    fieldalignment = false,
                    nilness = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                semanticTokens = true,
            },
        },
    }),
    lang.server("basedpyright", {
        -- python
        settings = {
            basedpyright = {
                analysis = { typeCheckingMode = "standard" }, -- default "recommended" is very noisy
            },
        },
    }),
    lang.server("html"),
    lang.server("jsonls"), -- json
    lang.server("kotlin_lsp"),
    lang.server("lua_ls", {
        -- https://luals.github.io/wiki/configuration/#neovim
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
            },
        },
    }),
    lang.server("tailwindcss"),
    lang.server("ts_ls", {
        -- Prevent conflict with denols
        root_markers = { "package.json" },
        single_file_support = false,
    }),
    lang.server("yamlls"),
}

local server_names = function(servers)
    return arr.map(servers, function(s) return s.name end)
end

return {
    -- https://github.com/mason-org/mason.nvim
    {
        "mason-org/mason.nvim",
        lazy = false, -- puts mason/bin on PATH so conform finds the formatters
        opts = {},
    },
    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
    -- installs non-LSP tools (formatters); LSP servers are installed by mason-lspconfig below
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = { "prettierd", "ruff", "stylua" },
        },
    },
    -- Autocompletion
    -- https://cmp.saghen.dev/
    {
        "saghen/blink.cmp",
        version = "1.*", -- downloads a prebuilt fuzzy matcher for this version
        event = "InsertEnter",
        dependencies = { "rafamadriz/friendly-snippets" },
        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "default",
                ["<C-Space>"] = { "show", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<Enter>"] = { "accept", "fallback" },
            },
            sources = {
                default = { "lsp", "snippets" },
            },
        },
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "mason-org/mason-lspconfig.nvim" },
        },
        config = function()
            -- Configure all LSP servers using vim.lsp.config (Neovim 0.11+)
            -- blink.cmp adds its completion capabilities automatically
            for _, s in ipairs(lsp_servers) do
                vim.lsp.config(s.name, s.setup)
            end

            -- Enable all configured servers
            vim.lsp.enable(server_names(lsp_servers))

            -- Mason for auto-installation
            require("mason-lspconfig").setup({
                ensure_installed = server_names(lsp_servers),
                automatic_enable = false, -- servers are enabled explicitly with vim.lsp.enable above
            })

            -- LSP keymaps for the attached buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local function map(lhs, rhs)
                        vim.keymap.set("n", lhs, rhs, { buffer = args.buf })
                    end

                    map("K", vim.lsp.buf.hover)
                    map("gd", vim.lsp.buf.definition)
                    map("gD", vim.lsp.buf.declaration)
                    map("gi", vim.lsp.buf.implementation)
                    map("go", vim.lsp.buf.type_definition)
                    -- nowait: Neovim 0.12's default grn/gra/grr/gri/grt would otherwise delay gr
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = args.buf, nowait = true })
                    map("gs", vim.lsp.buf.signature_help)
                    map("gl", vim.diagnostic.open_float)
                    map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
                    map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)
                end,
            })
        end,
    },
}

