return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 200,
    win = {
      border = "rounded",
    },
  },
  config = function(_, opts)
    local which_key = require("which-key")

    which_key.setup(opts)
    which_key.add({
      { "<leader>c", group = "Opencode" },
      { "<leader>d", group = "Diff" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>r", group = "Remote" },
      { "<leader>x", group = "Diagnostics/Lists" },
    })
  end,
}
