require("core.options")
require("core.keymaps")

-- Disable unused language providers. All plugins in this config are pure Lua,
-- so the Node/Python/Perl/Ruby bridges are dead weight. Re-enable any of these
-- if you install a plugin that requires it.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  rocks = { enabled = false },
})

-- Colorscheme setup
local my_colorscheme = "everforest" -- "gruvbox", "everforest"
local my_background = "dark"

local function set_colorscheme(scheme, background)
  vim.o.background = background

  local success = pcall(vim.cmd.colorscheme, scheme)
  if not success then
    vim.notify("Colorscheme '" .. scheme .. "' not found!", vim.log.levels.WARN)
  end
end

set_colorscheme(my_colorscheme, my_background)
