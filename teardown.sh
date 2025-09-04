#!/usr/bin/env bash
set -euo pipefail

echo "Enter your pw for sudo access..."
sudo -v

keep_sudo_alive() {
  while true; do
    sudo -v
    sleep 50
  done &
  SUDO_PID=$!
}

keep_sudo_alive

echo "lets start again cause we be testing..."

# Check if we can use Ansible approach
if command -v ansible-playbook &>/dev/null && [ -f ~/Projects/github/dotfiles/playbooks/teardown.yml ]; then
  echo "Using Ansible teardown..."
  cd ~/Projects/github/dotfiles
  ansible-playbook playbooks/teardown.yml
else
  echo "Ansible not available, using shell teardown..."
  
  # Fallback to shell-based removal
  remove_packages() {
    local packages=("$@")
    for package in "${packages[@]}"; do
      if rpm -q "$package" &>/dev/null; then
        echo "removing this bad boy: $package..."
        sudo dnf remove -y "$package"
      else
        echo "$package not installed, skipping..."
      fi
    done
  }

  remove_packages "ansible" "git" "python3-pip"

  if [ -d ~/Projects/github/dotfiles ]; then
    echo "Removing dotfiles directory..."
    rm -rf ~/Projects/github/dotfiles
  else
    echo "Dotfiles directory not found, skipping..."
  fi

  echo "clean up"
  sudo dnf autoremove -y
fi

kill $SUDO_PID 2>/dev/null || true

echo "teardown done bro"
