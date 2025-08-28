return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		local sources = {
			-- === Diagnostics ===
			null_ls.builtins.diagnostics.dotenv_linter,
			require("none-ls.diagnostics.ruff"),
		}
		null_ls.setup({
			sources = sources,
		})
	end,
}
