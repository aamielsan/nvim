-- One shared terminal: each key moves it to that position, or hides it if it's already there.
-- `exit` in the shell closes it for good; the next key starts a new one.
local terminal_positions = {
    float = { position = "float", border = "rounded", width = 0.55, height = 0.75 },
    bottom = { position = "bottom", border = "none", height = 15 }, -- splits only use one size
    right = { position = "right", border = "none", width = 0.4 },
}
local function terminal(where)
    local win = terminal_positions[where]
    local term = Snacks.terminal.get(nil, { create = false })
    if not (term and term:buf_valid()) then
        return Snacks.terminal.open(nil, { win = win })
    end
    if term:valid() and term.opts.position == win.position then
        return term:hide()
    end
    term:hide()
    term.opts = vim.tbl_extend("force", term.opts, win)
    term:show()
    vim.cmd.startinsert() -- back to typing in the shell, as when it first opens
end

return {
    -- https://github.com/tpope/vim-sleuth
    { "tpope/vim-sleuth" },
    -- https://github.com/windwp/nvim-autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    -- https://github.com/kylechui/nvim-surround
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = true
    },
    -- https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md
    {
        "folke/snacks.nvim",
        opts = {
            terminal = {},
            styles = {
                terminal = {
                    keys = {
                        -- Ctrl-Q leaves terminal mode without sending anything to the program;
                        -- Esc Esc still works, but its first Esc reaches the program
                        stop_insert = { "<c-q>", function() vim.cmd.stopinsert() end, mode = "t", desc = "Leave terminal mode" },
                    },
                },
            },
        },
        keys = {
            { "<leader>tf", function() terminal("float") end, desc = "Terminal Float" },
            { "<leader>th", function() terminal("bottom") end, desc = "Terminal Horizontal" },
            { "<leader>tv", function() terminal("right") end, desc = "Terminal Vertical" },
        },
    },
}
