-- Import my core utils
require("core.options")
require("core.keymaps")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  rocks = { enabled = false }
})

-- Colorscheme setup
local my_colorscheme =
"miasma"                        -- options: "gruvbox-material", "gruvbox", "ayu", "bathory", "habamax", "taake", "yugen", "ashen", "everforest", "miasma"
local my_background = "dark"        -- options: "dark", "light"

local function set_colorscheme(scheme, background)
  local success, _ = pcall(vim.cmd.colorscheme, scheme)
  vim.o.background = background

  if not success then
    vim.notify("Colorscheme '" .. scheme .. "' not found!", vim.log.levels.WARN)
    return
  end
end

set_colorscheme(my_colorscheme, my_background)
