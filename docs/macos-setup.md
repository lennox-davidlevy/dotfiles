# macOS Setup Guide

Complete guide for bootstrapping a new macOS machine (Intel or Apple Silicon) with your dotfiles.

## Prerequisites

- macOS 12.0 (Monterey) or later
- Admin access (sudo privileges)
- Internet connection
- Xcode Command Line Tools (will be installed by Homebrew if missing)

## Architecture Support

This setup works on both:
- **Intel Macs** (x86_64) - Homebrew installs to `/usr/local`
- **Apple Silicon** (arm64/M1/M2/M3/M4) - Homebrew installs to `/opt/homebrew`

The scripts automatically detect your architecture and configure paths accordingly.

## Quick Start

### 1. Install Xcode Command Line Tools (if needed)

```bash
xcode-select --install
```

### 2. Clone this repository

```bash
mkdir -p ~/Projects/github
git clone https://github.com/lennox-davidlevy/dotfiles.git -b new_macos ~/Projects/github/dotfiles
cd ~/Projects/github/dotfiles
```

### 3. Run the bootstrap script

```bash
./bootstrap-macos.sh
```

This will:
- Install Homebrew (if not present)
- Install Ansible and Git
- Install all packages and applications
- Set up Oh My Zsh with Powerlevel10k
- Install and configure development tools (pyenv, fnm, uv)
- Symlink all configuration files
- Set Zsh as your default shell

### 4. Restart your terminal

```bash
exec zsh
```

## What Gets Installed

### Core Tools
- **Homebrew** - Package manager for macOS
- **Python 3.12** (via Homebrew) + **pyenv** for version management
- **Node.js** (via fnm) + **fnm** for version management
- **Go**, **Rust** - Programming languages
- **Neovim** - Modern text editor
- **tmux** - Terminal multiplexer
- **Git** - Version control

### Development Tools
- **uv** - Fast Python package installer
- **pyenv** - Python version management
- **fnm** - Fast Node.js version manager
- **ripgrep** (rg) - Better grep
- **fd** - Better find
- **bat** - Better cat with syntax highlighting
- **eza** - Modern ls replacement
- **fzf** - Fuzzy finder
- **zoxide** - Smarter cd command
- **jq/yq** - JSON/YAML processors

### Applications (Casks)
- **Ghostty** - Modern GPU-accelerated terminal
- **Brave Browser** - Privacy-focused browser
- **Raycast** - Spotlight replacement (app launcher)
- **Rectangle** - Window management
- **Stats** - System monitor in menu bar
- **Nerd Fonts** - Patched fonts for terminal

### Optional Applications
- **Karabiner-Elements** - Advanced keyboard customization
- **1Password** - Password manager
- **Docker** - Containerization
- **Visual Studio Code** - Code editor

## Configuration Files

The following configurations are symlinked to your home directory:

```
~/.config/nvim/     → dotfiles/config/nvim/
~/.zshrc            → dotfiles/shell/.zshrc
~/.zsh_scripts/     → dotfiles/shell/.zsh_scripts/
~/.tmux.conf        → dotfiles/shell/.tmux.conf
~/.tmux-themepack/  → dotfiles/shell/.tmux-themepack/
~/.p10k.zsh         → dotfiles/shell/.p10k.zsh
```

## Development Environment Setup

### Python (pyenv + uv)

```bash
# List available Python versions
pyenv install --list

# Install a specific version
pyenv install 3.12.0

# Set global Python version
pyenv global 3.12.0

# Use uv for fast package management
uv pip install <package>
```

### Node.js (fnm)

```bash
# Install latest LTS
fnm install --lts

# Install specific version
fnm install 20.0.0

# Set default version
fnm default lts-latest

# Auto-switch based on .node-version or .nvmrc
# (already configured in .zshrc with --use-on-cd)
```

### Go

```bash
# Go is installed via Homebrew
go version

# GOPATH is automatically set
echo $GOPATH  # Should show ~/go
```

## Window Management (Optional)

This setup does **not** include a tiling window manager by default. You can manually install:

### Option 1: Aerospace (Recommended - i3-like)
```bash
brew install --cask nikitabobko/tap/aerospace
```

- Native i3-like tiling for macOS
- No SIP changes required
- Simple configuration
- [Documentation](https://github.com/nikitabobko/AeroSpace)

### Option 2: yabai + skhd (Advanced)
```bash
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
```

- More powerful but requires SIP adjustments
- Complex setup
- [Documentation](https://github.com/koekeishiya/yabai)

### Option 3: Rectangle (Simplest)
```bash
brew install --cask rectangle
# Already installed by default!
```

- Simple window snapping
- No configuration needed
- Great for beginners

## Shell Features

### Modern CLI Aliases

If `eza` is installed:
- `ls` → `eza --icons`
- `ll` → `eza -lah --icons`
- `la` → `eza -a --icons`
- `lt` → `eza --tree --icons`

### Fuzzy Finding (fzf)

- `Ctrl+R` - Search command history
- `Ctrl+T` - Search files
- `Alt+C` - Change directory

### Smarter Navigation (zoxide)

```bash
# After visiting directories a few times
z projects      # Jump to ~/Projects/github/dotfiles
z dot           # Jump to ~/Projects/github/dotfiles
```

### Docker Aliases

```bash
dk    # docker
dc    # docker ps
dca   # docker ps -a
dr    # docker run
de    # docker exec -it
ds    # docker stop
```

### Kubernetes Aliases

```bash
kb    # kubectl
```

## Troubleshooting

### Homebrew not in PATH

If Homebrew commands aren't found, add to current session:

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel
eval "$(/usr/local/bin/brew shellenv)"
```

### Oh My Zsh installation prompts

The bootstrap handles this automatically. If prompted, choose "yes" to replace your .zshrc (it will be backed up).

### Permission issues with Ansible

Run the bootstrap script again - it handles sudo keep-alive.

### Fonts not appearing

After installation, restart your terminal application and select a Nerd Font:
- MesloLGS NF
- JetBrainsMono Nerd Font

### pyenv or fnm not working

Restart your shell:
```bash
exec zsh
```

## Customization

### Adding more packages

Edit `playbooks/packages-macos.yml`:

```yaml
packages:
  development:
    - your-package-name

casks:
  productivity:
    - your-app-name
```

Then run:
```bash
cd ~/Projects/github/dotfiles
ansible-playbook playbooks/bootstrap-macos.yml
```

### Modifying shell configuration

Edit files in `shell/`:
- `.zshrc` - Main Zsh configuration
- `.zsh_scripts/aliases.zsh` - Command aliases
- `.zsh_scripts/functions.zsh` - Custom functions
- `.zsh_scripts/tmux-autostart.zsh` - Auto-start tmux

Changes take effect after:
```bash
source ~/.zshrc
```

### Neovim plugins

Edit `config/nvim/lua/plugins/` and restart Neovim. Lazy.nvim will auto-install new plugins.

## Teardown

To remove everything installed by this bootstrap:

```bash
cd ~/Projects/github/dotfiles
./teardown-macos.sh
```

This will:
- Remove all Homebrew packages installed by the bootstrap
- Remove symlinks (your original files are backed up as `.bak`)
- Clean up Homebrew cache

## Differences from Fedora Setup

| Component | Fedora | macOS |
|-----------|--------|-------|
| Package Manager | dnf | Homebrew |
| Window Manager | i3 | Aerospace/yabai/Rectangle |
| App Launcher | rofi | Raycast |
| Compositor | picom | Built-in |
| Display Server | X11 | Native |
| Clipboard | xclip | pbcopy/pbpaste |
| Font Directory | ~/.local/share/fonts | ~/Library/Fonts |

## Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Neovim](https://neovim.io/)
- [pyenv](https://github.com/pyenv/pyenv)
- [fnm](https://github.com/Schniz/fnm)
- [uv](https://github.com/astral-sh/uv)

## Contributing

Found an issue or want to improve the setup? Open an issue or PR!

## License

MIT - Do whatever you want with this!
