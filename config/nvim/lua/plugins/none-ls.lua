return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.dotenv_linter.with({
          args = { "check", "$FILENAME" },
        }),
        null_ls.builtins.diagnostics.ansiblelint,
      },
    })
  end,
}
