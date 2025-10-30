# Dotfiles - macOS Setup

Modern development environment configuration for macOS (Intel & Apple Silicon).

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/lennox-davidlevy/dotfiles.git -b new_macos ~/Projects/github/dotfiles

# Run bootstrap
cd ~/Projects/github/dotfiles
./bootstrap-macos.sh

# Restart your terminal
exec zsh
```

## 📦 What's Included

### Core Tools
- **Neovim** - Modern text editor with custom configuration
- **tmux** - Terminal multiplexer with Powerlevel10k theme
- **Zsh** - Shell with Oh My Zsh and Powerlevel10k
- **Homebrew** - Package manager (auto-detects Intel vs Apple Silicon)

### Development Tools
- **Python** - Managed via `pyenv` (version manager) + `uv` (fast package installer)
- **Node.js** - Managed via `fnm` (Fast Node Manager)
- **Go** - Latest stable version
- **Rust** - Latest stable version
- **Modern CLI tools**: `ripgrep`, `fd`, `bat`, `eza`, `fzf`, `zoxide`

### Applications
- **Ghostty** - Modern GPU-accelerated terminal
- **Brave Browser** - Privacy-focused browser
- **Raycast** - Powerful app launcher (Spotlight replacement)
- **Rectangle** - Window management utility
- **Stats** - System monitor in menu bar
- **Nerd Fonts** - Patched fonts for terminal icons

## 📖 Documentation

- **[Setup Guide](docs/macos-setup.md)** - Complete installation and configuration guide
- **[AGENTS.md](AGENTS.md)** - Developer guidelines and code style

## 🏗️ Architecture Support

Works seamlessly on both:
- **Intel Macs** (x86_64) - Homebrew at `/usr/local`
- **Apple Silicon** (M1/M2/M3/M4) - Homebrew at `/opt/homebrew`

Scripts automatically detect your architecture and configure paths accordingly.

## 🗂️ Repository Structure

```
dotfiles/
├── bootstrap-macos.sh        # Main setup script
├── teardown-macos.sh         # Cleanup script
├── config/
│   └── nvim/                 # Neovim configuration
├── playbooks/
│   ├── bootstrap-macos.yml   # Ansible playbook
│   └── packages-macos.yml    # Package definitions
├── shell/
│   ├── .zshrc               # Zsh configuration
│   ├── .tmux.conf           # tmux configuration
│   └── .zsh_scripts/        # Custom aliases & functions
├── fonts/                    # Nerd Fonts
└── docs/                     # Documentation
```

## 🎨 Features

### Shell Enhancements
- **Modern aliases**: `eza` for colorful file listings with icons
- **Fuzzy finding**: `fzf` for command history and file search (`Ctrl+R`, `Ctrl+T`)
- **Smart navigation**: `zoxide` for intelligent directory jumping
- **Docker shortcuts**: `dk`, `dc`, `dca` for common Docker commands
- **Clipboard integration**: tmux copy mode works with macOS clipboard

### Development Environment
```bash
# Python version management
pyenv install 3.12.0
pyenv global 3.12.0

# Fast package installation with uv
uv pip install requests

# Node.js version management
fnm install 20
fnm default lts-latest

# Auto-switch Node versions based on .nvmrc
# (configured with --use-on-cd)
```

## 🔧 Customization

### Add More Packages

Edit `playbooks/packages-macos.yml`:

```yaml
packages:
  development:
    - your-package-here

casks:
  productivity:
    - your-app-here
```

Then run:
```bash
ansible-playbook playbooks/bootstrap-macos.yml
```

### Modify Shell Config

Files in `shell/` are symlinked to your home directory:
- `.zshrc` - Main shell configuration
- `.zsh_scripts/aliases.zsh` - Command aliases
- `.zsh_scripts/functions.zsh` - Custom functions

Changes take effect after:
```bash
source ~/.zshrc
```

## 🪟 Window Management (Optional)

The bootstrap doesn't install a window manager by default. Choose one:

### Aerospace (Recommended - i3-like)
```bash
brew install --cask nikitabobko/tap/aerospace
```
- i3-style tiling for macOS
- No SIP changes needed
- [Documentation](https://github.com/nikitabobko/AeroSpace)

### yabai + skhd (Advanced)
```bash
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
```
- More powerful but requires SIP adjustments
- [Documentation](https://github.com/koekeishiya/yabai)

### Rectangle (Already Installed)
- Simple window snapping
- Works out of the box

## 🗑️ Teardown

To remove everything:

```bash
cd ~/Projects/github/dotfiles
./teardown-macos.sh
```

This will:
- Remove all installed packages
- Remove symlinks (restores backups)
- Optionally remove Oh My Zsh, Powerlevel10k, and dotfiles directory

## 🆚 Differences from Linux Setup

| Component | Linux (Fedora) | macOS |
|-----------|----------------|-------|
| Package Manager | dnf | Homebrew |
| Window Manager | i3 | Optional (Aerospace/yabai) |
| App Launcher | rofi | Raycast |
| Clipboard | xclip | pbcopy/pbpaste |
| Font Directory | ~/.local/share/fonts | ~/Library/Fonts |

**Note:** Linux configs are preserved in the `fedora` git branch. Access with `git checkout fedora`.

## 📝 Notes

- Your original `.zshrc` is backed up as `.zshrc.bak`
- Neovim config uses Lazy.nvim for plugin management
- tmux uses Powerlevel10k theme with custom status bar
- All configs support both Intel and Apple Silicon Macs

## 🤝 Contributing

Found an issue or have improvements? Feel free to open an issue or PR!

## 📄 License

MIT - Use however you'd like!

---

**Made with ❤️ for macOS developers**
