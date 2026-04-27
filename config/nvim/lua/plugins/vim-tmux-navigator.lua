return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  init = function()
    -- Disable the default keymaps so we can define our own that respect terminal buffers
    vim.g.tmux_navigator_no_mappings = 1
  end,
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Navigate left (window/tmux)" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Navigate down (window/tmux)" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Navigate up (window/tmux)" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate right (window/tmux)" },
    -- Terminal-mode mappings: escape terminal first, then navigate
    { "<C-h>", [[<C-\><C-n><cmd>TmuxNavigateLeft<cr>]],  mode = "t", desc = "Navigate left from terminal" },
    { "<C-j>", [[<C-\><C-n><cmd>TmuxNavigateDown<cr>]],  mode = "t", desc = "Navigate down from terminal" },
    { "<C-k>", [[<C-\><C-n><cmd>TmuxNavigateUp<cr>]],    mode = "t", desc = "Navigate up from terminal" },
    { "<C-l>", [[<C-\><C-n><cmd>TmuxNavigateRight<cr>]], mode = "t", desc = "Navigate right from terminal" },
  },
}
