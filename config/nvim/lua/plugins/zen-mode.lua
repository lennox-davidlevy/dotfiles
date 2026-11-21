return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  keys = {
    { "<leader>z", "<Cmd>ZenMode<CR>", desc = "Toggle Zen Mode" },
  },
  dependencies = {
    {
      "folke/twilight.nvim",
      cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
      opts = {
        dimming = { alpha = 0.25 },
        context = 10,
        treesitter = true,
      },
    },
  },
  opts = {
    window = {
      backdrop = 0.85,
      width = 100,
      height = 1,
      options = {
        number = false,
        relativenumber = false,
        signcolumn = "no",
        foldcolumn = "0",
        cursorline = false,
        cursorcolumn = false,
        colorcolumn = "",
        list = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
      twilight = { enabled = true },
      gitsigns = { enabled = true },
    },
  },
}
