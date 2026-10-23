-- Claude Code inside Neovim, connected through Claude's IDE protocol (`/ide`): Claude sees the
-- current file, selection and diagnostics, and its edits open as diffs (:w accepts, :q rejects).
-- https://github.com/coder/claudecode.nvim
return {
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        event = "VeryLazy", -- start the /ide server with Neovim, so Claude in a tmux window can connect too
        opts = {
            -- DNB's wrapper where it's installed (work laptop), plain `claude` elsewhere
            terminal_cmd = vim.fn.executable("raicode") == 1 and "raicode" or nil,
            terminal = {
                -- Esc goes to Claude only (it stops a running task); Ctrl-Q leaves terminal mode
                snacks_win_opts = { keys = { term_normal = false } },
            },
        },
        keys = {
            { "<C-,>", "<cmd>ClaudeCodeFocus<cr>", mode = { "n", "t", "i", "x" }, desc = "Claude: focus or toggle" },
            { "<leader>aa", "<cmd>ClaudeCode<cr>", desc = "Claude: toggle" },
            { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Claude: toggle" },
            { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Claude: resume a session" },
            { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Claude: continue the last session" },
            { "<leader>af", "<cmd>ClaudeCodeAdd %<cr>", desc = "Claude: add the current file" },
            { "<leader>av", "<cmd>ClaudeCodeSend<cr>", mode = "x", desc = "Claude: send the selection" },
            { "<leader>at", "<cmd>ClaudeCodeSend<cr>", mode = "x", desc = "Claude: send the selection" },
        },
    },
}
