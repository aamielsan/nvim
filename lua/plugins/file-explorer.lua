-- focus the explorer, or close it when it already has focus
local function toggle()
    local explorer = Snacks.picker.get({ source = "explorer" })[1]
    if explorer and explorer:is_focused() then
        explorer:close()
    elseif explorer then
        explorer:focus()
    else
        Snacks.explorer()
    end
end

-- https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
return {
    {
        "folke/snacks.nvim",
        lazy = false, -- needed to replace netrw when opening a directory
        priority = 1000,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            explorer = {
                replace_netrw = true,
            },
            picker = {
                sources = {
                    explorer = {
                        layout = { layout = { width = 0.2 } },
                    },
                },
            },
        },
        keys = {
            { "<Leader>l", toggle, desc = "Explorer: Toggle" },
        },
    },
}
