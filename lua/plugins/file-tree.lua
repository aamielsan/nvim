
return {
    {
        'nvim-tree/nvim-tree.lua',
        tag = 'v0.99',
        config = true,
        init = function()
            local focusOrToggle = function ()
                local nvim_tree = require("nvim-tree.api")
                local current_buf = vim.api.nvim_get_current_buf()
                local current_buftype = vim.api.nvim_get_option_value("filetype", { buf = current_buf })
                if current_buftype == "NvimTree" then
                    nvim_tree.tree.toggle()
                else
                    nvim_tree.tree.focus()
                end
            end

            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.keymap.set("n", "<C-t>", focusOrToggle)
        end,
    },
    {
        'nvim-tree/nvim-web-devicons',
        branch = 'master'
    }
}
