vim.g.mapleader = ","

local undodir = vim.fn.stdpath("config") .. "/.undodir"
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

local options = {
	-- style
	number = true,
	signcolumn = "yes",
	termguicolors = true,
	cmdheight = 1,
	showmode = false,
  wrap = false,
  hlsearch = false,
  showtabline = 0,

	-- functionality
	ignorecase = true,
	splitright = true,
	splitbelow = true,
	clipboard = "unnamedplus",
	expandtab = true,
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
	mouse = "",
  swapfile = false,

	-- undo tree
	undofile = true,
	undodir = undodir,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Suppress deprecation warnings
vim.deprecate = function() end
