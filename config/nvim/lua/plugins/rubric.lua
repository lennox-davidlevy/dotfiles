-- Rubric: Jev picks a part for each `::: words` line in Markdown, shown as
-- ghost text. Attaches only inside a folder with rubric.md.
-- Insert mode: <M-l> accepts and pins, <M-n>/<M-p> switch to the runner-up.
return {
  dir = "~/Projects/github/rubric/editors/nvim",
  name = "rubric",
  ft = "markdown",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    require("rubric").setup({
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })
  end,
}
