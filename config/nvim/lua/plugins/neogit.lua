return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>dv", "<Cmd>DiffviewOpen<CR>", mode = "n", desc = "Open Diffview" },
    { "<leader>dc", "<Cmd>DiffviewClose<CR>", mode = "n", desc = "Close Diffview" },
    {
      "<leader>dh",
      function()
        if vim.wo.diff then
          vim.cmd("normal! ]c")
        end
      end,
      mode = "n",
      desc = "Next diff hunk",
    },
    {
      "<leader>dH",
      function()
        if vim.wo.diff then
          vim.cmd("normal! [c")
        end
      end,
      mode = "n",
      desc = "Previous diff hunk",
    },
    { "<leader>dg", "<Cmd>diffget //2<CR>", mode = "n", desc = "Get hunk from other buffer" },
    { "<leader>dG", "<Cmd>diffput //2<CR>", mode = "n", desc = "Put hunk to other buffer" },
    { "<leader>gg", "<Cmd>Neogit<CR>", mode = "n", desc = "Open Neogit" },
    { "<leader>gC", "<Cmd>Neogit commit<CR>", mode = "n", desc = "Neogit Commit" },
    { "<leader>gp", "<Cmd>Neogit pull<CR>", mode = "n", desc = "Neogit Pull" },
    { "<leader>gP", "<Cmd>Neogit push<CR>", mode = "n", desc = "Neogit Push" },
  },
}
