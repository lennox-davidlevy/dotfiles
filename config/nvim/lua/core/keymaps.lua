local map = vim.keymap.set
local function opts(desc)
  return { noremap = true, silent = true, desc = desc }
end

-- Escape sequence
map("i", "jk", "<Esc>", opts("Exit insert mode"))

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts("Focus left window"))
map("n", "<C-j>", "<C-w>j", opts("Focus lower window"))
map("n", "<C-k>", "<C-w>k", opts("Focus upper window"))
map("n", "<C-l>", "<C-w>l", opts("Focus right window"))

-- Splits
map("n", "<leader>s", "<Cmd>split<CR><C-w>j", opts("Split below"))
map("n", "<leader>v", "<Cmd>vsplit<CR><C-w>l", opts("Split right"))

map("n", "tt", "<Cmd>tab split<CR>", opts("Open buffer in new tab"))
map("n", "tr", "<Cmd>tabclose<CR>", opts("Close current tab"))
map("n", "<leader>o", "<Cmd>only<CR>", opts("Close other windows"))

-- Turn off search highlight
map("n", "<CR>", "<Cmd>nohlsearch<CR>", opts("Clear search highlight"))

-- Stay in indent mode
map("v", "<", "<gv", opts("Indent left and reselect"))
map("v", ">", ">gv", opts("Indent right and reselect"))
