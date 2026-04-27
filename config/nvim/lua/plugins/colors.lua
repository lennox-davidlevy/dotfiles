return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "phha/zenburn.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "sainnhe/gruvbox-material",
    lazy = true,
  },
  {
    "ayu-theme/ayu-vim",
    lazy = true,
  },
  {
    "xero/miasma.nvim",
    lazy = true,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {},
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = true,
    config = function()
      require("everforest").setup({})
    end,
  },
}
