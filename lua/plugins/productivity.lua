-- One shared terminal: each key moves it to that position, or hides it if it's already there.
-- `exit` in the shell closes it for good; the next key starts a new one.
local terminal_positions = {
    float = { position = "float", border = "rounded", width = 0.9, height = 0.9 }, -- set both: a moved terminal keeps any size not set here
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
    -- :Reader shows the buffer like an e-reader: Markdown rendered in a centred page. j/k move by screen line
    -- (a paragraph is one long line), or by numbered line with a count. m cycles the margins, # toggles line
    -- numbers, :q leaves. render-markdown only loads, and only renders, for :Reader.
    -- https://github.com/MeanderingProgrammer/render-markdown.nvim
    {
        "MeanderingProgrammer/render-markdown.nvim",
        lazy = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            enabled = false, -- only the buffers :Reader turns it on for
            anti_conceal = { enabled = false }, -- keep the cursor line rendered too
        },
        init = function()
            local margins = { { "Narrow", 100 }, { "Normal", 80 }, { "Wide", 64 } } -- page width in columns
            vim.api.nvim_create_user_command("Reader", function()
                require("render-markdown").buf_enable()
                local page = require("snacks").zen({
                    toggles = { dim = false },
                    win = {
                        minimal = true,
                        -- margins in the page's colour that hide the text behind (the default dims to black)
                        backdrop = { transparent = false, bg = require("snacks").util.color("Normal", "bg") },
                        wo = { wrap = true, linebreak = true, breakindent = true, smoothscroll = true },
                    },
                })
                local function apply() -- the choices live in all-caps globals, which ShaDa keeps across sessions
                    local numbers = vim.g.READER_NUMBERS == 1
                    page.opts.width = margins[vim.g.READER_MARGINS or 2][2]
                    page:update()
                    vim.wo[page.win].number, vim.wo[page.win].relativenumber = numbers, numbers -- like the editor
                end
                apply()
                local function map(lhs, rhs, expr) vim.keymap.set("n", lhs, rhs, { buffer = true, expr = expr }) end
                map("j", "v:count == 0 ? 'gj' : 'j'", true)
                map("k", "v:count == 0 ? 'gk' : 'k'", true)
                map("m", function()
                    vim.g.READER_MARGINS = (vim.g.READER_MARGINS or 2) % #margins + 1
                    apply()
                    vim.notify("Margins: " .. margins[vim.g.READER_MARGINS][1])
                end)
                map("#", function()
                    vim.g.READER_NUMBERS = vim.g.READER_NUMBERS == 1 and 0 or 1
                    apply()
                    vim.notify("Line numbers: " .. (vim.g.READER_NUMBERS == 1 and "on" or "off"))
                end)
            end, { desc = "Read the buffer in a centred column" })
        end,
    },
}
