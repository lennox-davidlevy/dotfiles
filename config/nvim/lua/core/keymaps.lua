local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Escape sequence
map("i", "jk", "<Esc>", { noremap = true })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Splits
map("n", "<leader>s", ":sp<CR> <C-w>j<CR>", opts)
map("n", "<leader>v", ":vsp<CR> <C-w>l<CR>", opts)

map("n", "tt", ":tab split<CR>", opts)
map("n", "tr", ":tabc<CR>", opts)
map("n", "<leader>o", ":on<CR>", opts)

-- Turn of highlight on search
map("n", "<CR>", "<Cmd>nohlsearch<CR>", { noremap = true, silent = true })

-- Stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")
