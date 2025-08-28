return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		lualine.setup({
			options = {
				theme = "tokyonight",
			},
			extensions = {
				"neo-tree",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					{
						function()
							local filepath = vim.fn.expand("%:p")
							if filepath == "" then return "[No Name]" end
							local filename = vim.fn.fnamemodify(filepath, ":t")
							local parent = vim.fn.fnamemodify(filepath, ":h:t")
							return parent .. "/" .. filename
						end,
						color = { fg = "#000000", bg = "#ffff00", gui = "bold" },
					},
				},
				lualine_x = { "fileformat", "filetype" },
				lualine_y = {},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
