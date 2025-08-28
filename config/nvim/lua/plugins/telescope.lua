return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
			{ "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Find Theme" },

			-- LSP/Diagnostics
			{ "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Find Diagnostics (Buffer)" },
			{ "<leader>fD", "<cmd>Telescope diagnostics<cr>", desc = "Find Diagnostics (Workspace)" },
			{ "<leader>fr", "<cmd>Telescope lsp_references<cr>", desc = "Find References" },
			{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Find Symbols" },
			{ "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Find Workspace Symbols" },

			-- Git
			{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
			{ "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Git Stash" },
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							-- ["qq"] = actions.close,
							["<CR>"] = function(prompt_bufnr)
								local selection = require("telescope.actions.state").get_selected_entry()
								if selection then
									actions.select_default(prompt_bufnr)
								else
                  return
								end
							end,
						},
						n = {
							["q"] = actions.close,
							["<CR>"] = function(prompt_bufnr)
								local selection = require("telescope.actions.state").get_selected_entry()
								if selection then
									actions.select_default(prompt_bufnr)
								else
                  return
								end
							end,
						},
					},
				},
				pickers = {
					buffers = {
						show_all_buffers = true,
						sort_lastused = true,
						theme = "dropdown",
						previewer = false,
					},
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
