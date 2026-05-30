return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      -- Keep built-in f/F/t/T/;/, behavior; only use flash via s/S/<c-s>.
      char = { enabled = false },
    },
  },
  keys = {
    {
      "s",
      function() require("flash").jump() end,
      mode = { "n", "x", "o" },
      desc = "Flash jump",
    },
    {
      "S",
      function() require("flash").treesitter() end,
      mode = { "n", "o" },
      desc = "Flash treesitter",
    },
    {
      "<c-s>",
      function() require("flash").toggle() end,
      mode = "c",
      desc = "Toggle Flash during search",
    },
  },
  config = function(_, opts)
    require("flash").setup(opts)

    local function set_flash_hls()
      vim.api.nvim_set_hl(0, "FlashLabel",    { bg = "#ff007c", fg = "#ffffff", bold = true })
      vim.api.nvim_set_hl(0, "FlashMatch",    { bg = "#2d4f67", fg = "#c8d3f5", bold = true })
      vim.api.nvim_set_hl(0, "FlashCurrent",  { bg = "#ff966c", fg = "#1b1d2b", bold = true })
      vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#545c7e" })
    end

    set_flash_hls()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_flash_hls })
  end,
}
