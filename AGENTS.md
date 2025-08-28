# AGENTS.md - Dotfiles Repository Guidelines

## Build/Test Commands
- **Neovim**: `nvim` (auto-loads config), `:source %` to reload, `:Lazy reload <plugin>` for single plugin
- **i3wm**: `i3 -C -c ~/.config/i3/config` to validate config
- **Shell**: `zsh -n ~/.zshrc` to check syntax, `bash -n <script>` for bash scripts
- **Rofi**: Test applets with `./<applet>.sh` from config/rofi/applets/bin/

## Code Style Guidelines

### Lua (Neovim configs)
- **Indentation**: 2 spaces, expandtab=true
- **Variables**: snake_case, always use `local` to avoid globals
- **Strings**: Double quotes consistently
- **Comments**: `-- comment` for single line only
- **Functions**: Local functions, descriptive names
- **Error handling**: Use `pcall()` for risky operations, `vim.notify()` for user feedback
- **Keymaps**: Include descriptive `desc` field, define in plugin specs when possible
- **Plugin configs**: Return lazy.nvim spec table format with proper dependencies/events
- **Requires**: Use `local var = require("module")` at top of functions

### Shell/Bash Scripts
- **Shebang**: `#!/usr/bin/env bash` for portability
- **Functions**: Use functions for reusable code, descriptive names
- **Variables**: UPPER_CASE for constants, lower_case for locals
- **Quotes**: Double quotes for variables, single for literals
- **Error handling**: Check command success with `||` and `&&`, use `set -e` for strict mode
- **Comments**: `# comment` with space after, describe complex logic
- **Formatting**: Consistent indentation (2 spaces), group related functions

### i3wm Config
- **Indentation**: 4 spaces consistently
- **Variables**: snake_case with `$` prefix (e.g., `$mod`, `$ws1`)
- **Workspace names**: Format `"number:Name"` (e.g., `"1:Terminal"`)
- **Key bindings**: Group related functionality, use vim-style hjkl navigation
- **Comments**: `# comment` followed by space
- **Window rules**: Use meaningful assignments and class/instance matching

### Zsh Config
- **Structure**: Group related settings (history, completion, path, environment)
- **Aliases**: Short, memorable names for common commands
- **Environment**: Export variables clearly, check directory existence before sourcing
- **Conditional loading**: Use `[ -f file ] && source file` pattern

## File Structure
- `config/i3/`: Window manager configuration (see config/i3/AGENTS.md)
- `config/nvim/`: Neovim editor setup (see config/nvim/AGENTS.md)
- `config/rofi/`: Application launcher and applets
- `shell/`: Zsh configuration and custom scripts
- `.gitignore`: Git ignore patterns for dotfiles

## Key Patterns
- **Error checking**: Always validate config changes before applying
- **Modularity**: Separate concerns into different files/modules
- **Documentation**: Comment complex configurations and custom functions
- **Testing**: Validate syntax and functionality after changes
- **Backup**: Keep backups when modifying critical system configs

## Environment Assumptions
- **OS**: Linux with systemd
- **Display**: X11 with i3 window manager
- **Terminal**: Alacritty or compatible
- **Shell**: Zsh with Oh My Zsh
- **Editor**: Neovim as default editor

## Security Notes
- Avoid hardcoding sensitive information
- Use secure paths and validate input in scripts
- Follow principle of least privilege for system modifications
