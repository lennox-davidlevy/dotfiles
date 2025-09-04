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

# Shell-based teardown function
shell_teardown() {
  echo "Using shell teardown..."

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
}

keep_sudo_alive

echo "lets start again cause we be testing..."

# Check if we can use Ansible approach
if command -v ansible-playbook &>/dev/null && [ -d ~/Projects/github/dotfiles ]; then
  echo "Using Ansible teardown..."
  cd ~/Projects/github/dotfiles
  echo "Pulling latest teardown configuration..."
  git pull origin fedora
  if [ -f playbooks/teardown.yml ]; then
    ansible-playbook playbooks/teardown.yml
    # Reuse the directory cleanup logic from shell_teardown
    cd ~
    if [ -d ~/Projects/github/dotfiles ]; then
      echo "Removing dotfiles directory..."
      rm -rf ~/Projects/github/dotfiles
    else
      echo "Dotfiles directory not found, skipping..."
    fi
  else
    echo "teardown.yml not found after pull, falling back to shell..."
    shell_teardown
  fi
else
  echo "Ansible not available, using shell teardown..."
  shell_teardown
fi

kill $SUDO_PID 2>/dev/null || true

echo "teardown done bro"
