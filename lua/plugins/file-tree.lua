local function toggle()
    local api = require("nvim-tree.api")
    local current_buf = vim.api.nvim_get_current_buf()
    local current_buftype = vim.api.nvim_get_option_value("filetype", { buf = current_buf })
    if current_buftype == "NvimTree" then
        api.tree.close()
    else
        api.tree.focus()
    end
end

return {
    'nvim-tree/nvim-tree.lua',
    version = "1.0.0",
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local function on_attach(bufnr)
            local api = require("nvim-tree.api")
            api.config.mappings.default_on_attach(bufnr)

            local function opts(desc)
                return {
                    desc = 'nvim-tree: ' .. desc,
                    -- buffer = bufnr, -- relevant if we want to override an existing keymap in nvim-tree buffer
                    noremap = true,
                    silent = true,
                    nowait = true,
                }
            end

            vim.keymap.set('n', '<Leader>j', toggle, opts("Toggle"))
        end

        require("nvim-tree").setup({
            disable_netrw = true,
            update_focused_file = {
                enable = true,
            },
            on_attach = on_attach,
        })

        -- open on start
        vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = require("nvim-tree.api").tree.open })
    end,
}
