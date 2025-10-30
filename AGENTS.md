# AGENTS.md - Dotfiles Repository Guidelines

## Platform
This repository is configured for **macOS** (Intel and Apple Silicon M1/M2/M3/M4).
Linux/Fedora configs are archived in `archive/linux/`.

## Build/Test Commands
- **Bootstrap**: `./bootstrap-macos.sh` to set up a new macOS machine
- **Neovim**: `nvim` (auto-loads config), `:source %` to reload, `:Lazy reload <plugin>` for single plugin
- **Shell**: `zsh -n ~/.zshrc` to check syntax, `bash -n <script>` for bash scripts
- **Ansible**: `ansible-playbook --syntax-check playbooks/bootstrap-macos.yml` to validate
- **Homebrew**: `brew doctor` to check for issues, `brew bundle check` to verify packages

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

### Ansible Playbooks (YAML)
- **Indentation**: 2 spaces, no tabs
- **Variables**: snake_case for variable names
- **Tasks**: Descriptive names explaining what the task does
- **Modules**: Use FQCN (Fully Qualified Collection Names) like `ansible.builtin.command`
- **Comments**: `#` for inline comments explaining complex logic
- **Conditionals**: Use `when:` clause for platform-specific tasks

### Zsh Config
- **Structure**: Group related settings (history, completion, path, environment)
- **Aliases**: Short, memorable names for common commands
- **Environment**: Export variables clearly, check directory existence before sourcing
- **Conditional loading**: Use `[ -f file ] && source file` pattern

## File Structure
- `config/nvim/`: Neovim editor setup (see config/nvim/AGENTS.md)
- `shell/`: Zsh configuration and custom scripts
- `playbooks/`: Ansible playbooks for bootstrap and teardown
- `fonts/`: Nerd Fonts for terminal use
- `docs/`: Documentation and setup guides
- `.gitignore`: Git ignore patterns for dotfiles

**Note:** Linux/Fedora configs are in the `fedora` git branch (not in this branch)

## Key Patterns
- **Error checking**: Always validate config changes before applying
- **Modularity**: Separate concerns into different files/modules
- **Documentation**: Comment complex configurations and custom functions
- **Testing**: Validate syntax and functionality after changes
- **Backup**: Keep backups when modifying critical system configs

## Environment Assumptions
- **OS**: macOS 12.0+ (Monterey or later)
- **Architecture**: Intel (x86_64) or Apple Silicon (arm64/M1/M2/M3/M4)
- **Package Manager**: Homebrew (auto-detected path: /opt/homebrew for ARM, /usr/local for Intel)
- **Terminal**: Ghostty (installed via bootstrap) or any compatible terminal
- **Shell**: Zsh (macOS default) with Oh My Zsh and Powerlevel10k
- **Editor**: Neovim as default editor
- **Window Manager**: Optional (Aerospace, yabai, or Rectangle - not installed by default)

## Security Notes
- Avoid hardcoding sensitive information
- Use secure paths and validate input in scripts
- Follow principle of least privilege for system modifications
- Use `$HOME` instead of hardcoded paths like `/Users/username`

## macOS-Specific Notes
- **Homebrew prefix**: Automatically detected based on architecture
  - Apple Silicon: `/opt/homebrew`
  - Intel: `/usr/local`
- **Clipboard**: Use `pbcopy` and `pbpaste` instead of `xclip`
- **Font installation**: Fonts go in `~/Library/Fonts/`
- **Path management**: Homebrew paths are added via `brew shellenv` in .zshrc
- **Development tools**:
  - Python: Managed via `pyenv` (installed to `~/.pyenv`)
  - Node.js: Managed via `fnm` (Fast Node Manager)
  - Python packages: Use `uv` for fast installation
- **Shell changes**: Use `chsh -s $(which zsh)` instead of editing `/etc/shells` directly
