vim.g.mapleader = ","
vim.g.maplocalleader = ","

local undodir = vim.fn.stdpath("config") .. "/.undodir"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end

local options = {
  -- Style
  number = true,
  signcolumn = "yes",
  termguicolors = true,
  cmdheight = 1,
  showmode = false,
  wrap = false,
  hlsearch = false,
  showtabline = 0,

  -- Functionality
  ignorecase = true,
  smartcase = true,
  splitright = true,
  splitbelow = true,
  clipboard = "unnamedplus",
  expandtab = true,
  tabstop = 4,
  softtabstop = 4,
  shiftwidth = 4,
  smartindent = true,
  mouse = "",
  swapfile = false,
  updatetime = 200,

  -- Persistent undo
  undofile = true,
  undodir = undodir,
}

for key, value in pairs(options) do
  vim.opt[key] = value
end
