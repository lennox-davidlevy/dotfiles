# AGENTS.md - Neovim Configuration

## Build/Test Commands
- Test config: `nvim` (auto-loads from init.lua)
- Reload config: `:source %` or restart Neovim  
- Test single plugin: `:Lazy reload <plugin-name>`
- Check syntax: `luacheck lua/` (if available)

## Code Style Guidelines
- **Indentation**: 2 spaces, expandtab=true (set in options.lua:24-26)
- **Variables**: snake_case, always use `local` to avoid globals
- **Strings**: Double quotes consistently
- **Comments**: `-- comment` for single line only
- **Plugin configs**: Return lazy.nvim spec table format
- **Requires**: Use `local var = require("module")` at top of functions
- **Error handling**: Use `pcall()` for risky operations, `vim.notify()` for user feedback
- **Keymaps**: Include descriptive `desc` field, define in plugin specs when possible

## File Structure
- `init.lua`: Entry point, requires core modules, sets up lazy.nvim
- `lua/core/`: Core config (options.lua, keymaps.lua)  
- `lua/plugins/`: One file per plugin/feature, lazy.nvim specs
- Plugin loading: Use `keys`, `cmd`, or `event` triggers for lazy loading

## Key Patterns
- Check `vim.v.shell_error` for command success
- Use `vim.fn.mkdir(path, "p")` for directory creation
- Colorscheme loading with pcall fallback (init.lua:28-36)
- LSP setup with capabilities from cmp_nvim_lsp (lsp-config.lua:63)
