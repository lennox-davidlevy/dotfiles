return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    input = { enabled = true }, -- Enhances vim.ui.input (used by opencode `ask()`)
    picker = { enabled = true }, -- Enhances vim.ui.select (used by opencode `select()`)
    notifier = { enabled = true }, -- Replaces vim.notify with a styled floating notifier
    bigfile = { enabled = true }, -- Disables expensive features for large files
    words = { enabled = true }, -- Highlights other instances of the word under cursor
  },
  keys = {
    {
      "<leader>gl",
      function()
        Snacks.lazygit()
      end,
      desc = "Open Lazygit",
    },

    -- Diagnostics / symbols / references / quickfix (snacks.picker)
    {
      "<leader>xx",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Diagnostics (Buffer)",
    },
    {
      "<leader>xX",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics (Workspace)",
    },
    {
      "<leader>xs",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP Symbols (Document)",
    },
    {
      "<leader>xS",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "LSP Symbols (Workspace)",
    },
    {
      "<leader>xr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "LSP References",
    },
    {
      "<leader>xq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>xl",
      function()
        Snacks.picker.loclist()
      end,
      desc = "Location List",
    },
  },
}
