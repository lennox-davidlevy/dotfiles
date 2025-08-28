return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	keys = {
		{ "<leader>rt", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Git hunk" },
		{ "<leader>rh", "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous Git hunk" },
		{ "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Git hunk" },
		{ "<leader>gb", "<cmd>Gitsigns blame_line<cr>", desc = "Git blame line" },
		{ "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Git diff this" },
	},
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "A" },
				change = { text = "C" },
				delete = { text = "D" },
				topdelete = { text = "T" },
				changedelete = { text = "X" },
				untracked = { text = "U" },
			},
			signcolumn = true,
			watch_gitdir = { follow_files = true },
			attach_to_untracked = false,
			update_debounce = 100,
			max_file_length = 40000,
		})
	end,
}
