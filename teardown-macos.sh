#!/usr/bin/env bash
set -euo pipefail

echo "=== macOS Teardown Script ==="
echo ""
echo "This will remove packages and configurations installed by bootstrap-macos.sh"
echo "Your original config files are backed up with .bak extension"
echo ""
read -p "Are you sure you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Teardown cancelled"
    exit 0
fi

echo ""
echo "Enter your password for sudo access..."
sudo -v

keep_sudo_alive() {
  while true; do
    sudo -v
    sleep 50
  done &
  SUDO_PID=$!
}

keep_sudo_alive

# Verify we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "Error: This teardown is for macOS only"
  exit 1
fi

echo ""
echo "Starting teardown..."

# Remove symlinks
echo ""
echo "Removing symlinks..."
symlinks=(
  "$HOME/.config/nvim"
  "$HOME/.zshrc"
  "$HOME/.zsh_scripts"
  "$HOME/.tmux.conf"
  "$HOME/.tmux-themepack"
  "$HOME/.p10k.zsh"
)

for link in "${symlinks[@]}"; do
  if [ -L "$link" ]; then
    echo "  Removing symlink: $link"
    rm "$link"
  fi
done

# Restore original .zshrc if backup exists
if [ -f "$HOME/.zshrc.bak" ]; then
  echo "  Restoring original .zshrc from backup"
  mv "$HOME/.zshrc.bak" "$HOME/.zshrc"
fi

# Remove packages via Homebrew
if command -v brew &> /dev/null; then
  echo ""
  echo "Removing Homebrew packages..."
  
  # Core packages
  packages=(
    "python@3.12"
    "tmux"
    "neovim"
    "ansible-lint"
    "node"
    "go"
    "rust"
    "uv"
    "pyenv"
    "fnm"
    "ripgrep"
    "fd"
    "bat"
    "eza"
    "jq"
    "yq"
    "tree"
    "htop"
    "fzf"
    "zoxide"
    "tldr"
    "gh"
    "ansible"
    "git"
  )
  
  for package in "${packages[@]}"; do
    if brew list "$package" &>/dev/null; then
      echo "  Removing: $package"
      brew uninstall --ignore-dependencies "$package" 2>/dev/null || true
    fi
  done
  
  # Casks
  echo ""
  echo "Removing Homebrew casks..."
  casks=(
    "font-meslo-lg-nerd-font"
    "font-jetbrains-mono-nerd-font"
  )
  
  for cask in "${casks[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
      echo "  Removing: $cask"
      brew uninstall --cask "$cask" 2>/dev/null || true
    fi
  done
  
  # Clean up
  echo ""
  echo "Cleaning up Homebrew..."
  brew cleanup
  brew autoremove
else
  echo "Homebrew not found, skipping package removal"
fi

# Optional: Remove Oh My Zsh
echo ""
read -p "Remove Oh My Zsh? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "  Removing Oh My Zsh..."
    rm -rf "$HOME/.oh-my-zsh"
  fi
fi

# Optional: Remove Powerlevel10k
echo ""
read -p "Remove Powerlevel10k? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if [ -d "$HOME/powerlevel10k" ]; then
    echo "  Removing Powerlevel10k..."
    rm -rf "$HOME/powerlevel10k"
  fi
fi

# Optional: Remove dotfiles directory
echo ""
read -p "Remove dotfiles directory? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if [ -d "$HOME/Projects/github/dotfiles" ]; then
    echo "  Removing dotfiles directory..."
    rm -rf "$HOME/Projects/github/dotfiles"
  fi
fi

# Optional: Remove pyenv
echo ""
read -p "Remove pyenv installation? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if [ -d "$HOME/.pyenv" ]; then
    echo "  Removing pyenv..."
    rm -rf "$HOME/.pyenv"
  fi
fi

# Optional: Remove fnm
echo ""
read -p "Remove fnm installation? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if [ -d "$HOME/.local/share/fnm" ]; then
    echo "  Removing fnm..."
    rm -rf "$HOME/.local/share/fnm"
  fi
fi

# Kill sudo keep-alive
kill $SUDO_PID 2>/dev/null || true

echo ""
echo "=== Teardown Complete! ==="
echo ""
echo "Notes:"
echo "  - Your original .zshrc has been restored (if backup existed)"
echo "  - Backup files (.bak) remain in your home directory"
echo "  - Homebrew itself was NOT removed"
echo "  - Some tools may have left config files in ~/.config/"
echo ""
echo "To restore default shell if changed:"
echo "  chsh -s /bin/zsh"
echo ""
