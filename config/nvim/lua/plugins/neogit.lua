return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		-- diffview
		{ "<leader>dv", "<cmd>DiffviewOpen<cr>", mode = "n", desc = "Open Diffview" },
		{ "<leader>dc", "<cmd>DiffviewClose<cr>", mode = "n", desc = "Close Diffview" },
		-- diff‐mode navigation & ops (only when &diff is set)
		{
			"<leader>dh",
			"<cmd>lua if vim.wo.diff then vim.cmd('normal! ]c') end<cr>",
			mode = "n",
			desc = "Next diff hunk",
		},
		{
			"<leader>dH",
			"<cmd>lua if vim.wo.diff then vim.cmd('normal! [c') end<cr>",
			mode = "n",
			desc = "Prev diff hunk",
		},
		{ "<leader>gd", "<cmd>diffget //2<cr>", mode = "n", desc = "Get hunk from other buffer" },
		{ "<leader>gD", "<cmd>diffput //2<cr>", mode = "n", desc = "Put hunk to other buffer" },

		-- neogit
		{ "<leader>gg", "<cmd>Neogit<cr>", mode = "n", desc = "Open Neogit" },
		{ "<leader>gc", "<cmd>Neogit commit<cr>", mode = "n", desc = "Neogit: commit" },
		{ "<leader>gp", "<cmd>Neogit pull<cr>", mode = "n", desc = "Neogit: pull" },
		{ "<leader>gP", "<cmd>Neogit push<cr>", mode = "n", desc = "Neogit: push" },
	},
}
