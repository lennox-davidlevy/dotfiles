#!/usr/bin/env bash
set -euo pipefail

# Ensure we start from a valid directory
cd ~

echo "=== macOS Bootstrap Script ==="
echo ""

# Verify we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "Error: This bootstrap is for macOS only"
  exit 1
fi

# Detect architecture
ARCH=$(uname -m)
echo "Detected architecture: $ARCH"

# Set Homebrew path based on architecture
if [[ "$ARCH" == "arm64" ]]; then
  BREW_PREFIX="/opt/homebrew"
else
  BREW_PREFIX="/usr/local"
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

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
  echo ""
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add Homebrew to PATH for this session
  eval "$($BREW_PREFIX/bin/brew shellenv)"
else
  echo ""
  echo "Homebrew already installed"
  eval "$($BREW_PREFIX/bin/brew shellenv)"
fi

# Update Homebrew
echo ""
echo "Updating Homebrew..."
brew update

# Install Ansible and Git
echo ""
echo "Installing Ansible and Git..."
brew install ansible git

# Clone or update dotfiles
if [ -d ~/Projects/github/dotfiles ]; then
  echo ""
  echo "Dotfiles directory exists. Updating..."
  cd ~/Projects/github/dotfiles
  git pull origin new_macos || true
else
  echo ""
  echo "Cloning dotfiles repository..."
  mkdir -p ~/Projects/github/
  git clone --depth 1 https://github.com/lennox-davidlevy/dotfiles.git -b new_macos ~/Projects/github/dotfiles
  cd ~/Projects/github/dotfiles
fi

# Run Ansible playbook
echo ""
echo "Running Ansible bootstrap playbook..."
ansible-playbook playbooks/bootstrap-macos.yml

# Kill sudo keep-alive
kill $SUDO_PID 2>/dev/null || true

echo ""
echo "=== Bootstrap Complete! ==="
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: exec zsh"
echo "2. Install window manager manually if desired (yabai/aerospace)"
echo "3. Configure any additional tools"
echo ""
