return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    input = { enabled = true }, -- Enhances vim.ui.input (used by opencode `ask()`)
    picker = { enabled = true }, -- Enhances vim.ui.select (used by opencode `select()`)
    notifier = { enabled = true }, -- Replaces vim.notify with a styled floating notifier
    bigfile = { enabled = true }, -- Disables expensive features for large files
    words = { enabled = true }, -- Highlights other instances of the word under cursor
  },
  keys = {
    {
      "<leader>gl",
      function()
        Snacks.lazygit()
      end,
      desc = "Open Lazygit",
    },
  },
}
