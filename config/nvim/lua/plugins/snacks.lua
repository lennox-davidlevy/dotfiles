return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    input = { enabled = true }, -- Enhances vim.ui.input (used by opencode `ask()`)
    picker = { enabled = true }, -- Enhances vim.ui.select (used by opencode `select()`)
  },
}
