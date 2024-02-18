-- Reference: https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
local lsp_servers = {
    'dockerls',
    'gopls',
    'gradle_ls',
    'html',
    'tsserver',
    'kotlin_language_server',
    'lua_ls',
    'jedi_language_server',
    'tailwindcss',
}

return {
    -- Reference: https://lsp-zero.netlify.app/v3.x/guide/lazy-loading-with-lazy-nvim.html
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {'L3MON4D3/LuaSnip'},
        },
        config = function()
            -- Here is where you configure the autocompletion settings.
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            -- And you can configure cmp even more, if you want to.
            local cmp = require('cmp')
            local select = {behavior = cmp.SelectBehavior.Select}

            cmp.setup({
                formatting = lsp_zero.cmp_format(),
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-j>'] = cmp.mapping.select_next_item(select),
                    ['<C-k>'] = cmp.mapping.select_prev_item(select),
                    ['<Enter>'] = cmp.mapping.confirm({select = true})
                })
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = {'LspInfo', 'LspInstall', 'LspStart'},
        event = {'BufReadPre', 'BufNewFile'},
        dependencies = {
            {'hrsh7th/cmp-nvim-lsp'},
            {'williamboman/mason-lspconfig.nvim'},
        },
        config = function()
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            --- if you want to know more about lsp-zero and mason.nvim
            --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)

            require('mason-lspconfig').setup({
                ensure_installed = lsp_servers,
                handlers = {
                    lsp_zero.default_setup,
                    gopls = function()
                        require('lspconfig').gopls.setup({
                            settings = {
                                gopls = {
                                    usePlaceholders = true
                                }
                            }
                        })
                    end
                }
            })
        end
    }
}
