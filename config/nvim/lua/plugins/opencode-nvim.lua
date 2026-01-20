return {
    "NickvanDyke/opencode.nvim",
    dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `snacks` provider.
        ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {
            provider = {
                enabled = "tmux",
                tmux = {
                    options = "-h -l 33%", -- Open in horizontal split with 33% width
                }
            }
        }

        -- Required for `opts.events.reload`.
        vim.o.autoread = true

        -- Opencode keymaps using <leader>c prefix (mnemonic: "code assistant" or "Claude")
        vim.keymap.set({ "n", "x" }, "<leader>cc", function() require("opencode").ask("@this: ", { submit = true }) end,
            { desc = "Ask opencode (chat)" })
        vim.keymap.set({ "n", "x" }, "<leader>cs", function() require("opencode").select() end,
            { desc = "Select opencode action" })
        vim.keymap.set({ "n", "t" }, "<leader>ct", function() require("opencode").toggle() end,
            { desc = "Toggle opencode terminal" })

        -- Operator mode for adding ranges/lines to opencode
        vim.keymap.set({ "n", "x" }, "<leader>co", function() return require("opencode").operator("@this ") end,
            { expr = true, desc = "Add range to opencode (operator)" })
        vim.keymap.set("n", "<leader>coo", function() return require("opencode").operator("@this ") .. "_" end,
            { expr = true, desc = "Add line to opencode" })

        -- Alternative: keep 'go' prefix for quick access
        vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
            { expr = true, desc = "Add range to opencode" })
        vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
            { expr = true, desc = "Add line to opencode" })

        -- Scroll opencode session
        vim.keymap.set("n", "<leader>cu", function() require("opencode").command("session.half.page.up") end,
            { desc = "Opencode scroll up" })
        vim.keymap.set("n", "<leader>cd", function() require("opencode").command("session.half.page.down") end,
            { desc = "Opencode scroll down" })
    end,
}
