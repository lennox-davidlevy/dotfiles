return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.dotenv_linter.with({
          args = { "check", "$FILENAME" },
        }),
        null_ls.builtins.diagnostics.ansiblelint,
        require("none-ls.diagnostics.ruff"),
      },
    })
  end,
}
