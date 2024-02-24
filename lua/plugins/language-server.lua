local arr = require("internal.array")
local lang = require("internal.language-server")

-- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
local lsp_servers = {
    lang.server("dockerls"),
    lang.server("gopls", {
        -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#configuration
        settings = {
            gopls = {
                gofumpt = true,
                codelenses = {
                    gc_details = false,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                analyses = {
                    fieldalignment = true,
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
    lang.server("gradle_ls"),
    lang.server("html"),
    lang.server("jedi_language_server"), -- python
    lang.server("jsonls"), -- json
    lang.server("kotlin_language_server"),
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
    lang.server("terraformls"),
    lang.server("tsserver"),
    lang.server("yamlls"),
}

local ensure_installed_from = function(servers)
    return arr.map(servers, function(s) return s.name end)
end

local handlers_from = function(servers, init)
    return arr.reduce(servers, function (acc, s)
        acc[s.name] = require("lspconfig")[s.name].setup(s.setup)
        return acc
    end, init)
end

return {
    -- https://lsp-zero.netlify.app/v3.x/guide/lazy-loading-with-lazy-nvim.html
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = true,
    },
    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require("cmp")
            local select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                formatting = lsp_zero.cmp_format(),
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<Tab>"] = cmp.mapping.select_next_item(select),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(select),
                    ["<Enter>"] = cmp.mapping.confirm({ select = true }),
                }),
            })
        end,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        cmd = {"LspInfo", "LspInstall", "LspStart"},
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "williamboman/mason-lspconfig.nvim" },
        },
        config = function()
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()

            -- format on save
            -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/abac76482ec3012a2b359ba956a74e2ffd33d46f/doc/md/lsp.md#enable-format-on-save
            lsp_zero.format_on_save({
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
                servers = {
                    ["gopls"] = {"go"},
                    ["tsserver"] = {"javascript", "typescript"},
                }
            })

            --- if you want to know more about lsp-zero and mason.nvim
            --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })

                -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
                if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
                    local semantic = client.config.capabilities.textDocument.semanticTokens
                    client.server_capabilities.semanticTokensProvider = {
                        full = true,
                        legend = {tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes},
                        range = true,
                    }
                end
            end)

            require("mason-lspconfig").setup({
                ensure_installed = ensure_installed_from(lsp_servers),
                handlers = handlers_from(lsp_servers, { lsp_zero.default_setup }),
            })
        end
    },
}
