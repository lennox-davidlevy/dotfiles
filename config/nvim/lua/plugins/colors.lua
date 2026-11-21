return {
  {
    "datsfilipe/vesper.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "savq/melange-nvim",
    lazy = true,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
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
    priority = 1000,
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    config = function()
      require("everforest").setup({})
    end,
  },
}
