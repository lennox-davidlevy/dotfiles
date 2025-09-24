return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = true,
		opts = {},
	},
	{
		"sainnhe/gruvbox-material",
		priority = 1000,
		lazy = false,
	},
	{
		"ayu-theme/ayu-vim",
		lazy = false,
		priority = 1000,
	},
	-- {
	-- 	"metalelf0/black-metal-theme-neovim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000,
		config = function()
			require("everforest").setup({
				-- Your config here
			})
		end,
	},
}
