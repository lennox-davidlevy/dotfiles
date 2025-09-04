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

if ! command -v dnf &> /dev/null; then
  echo "Error: this bootstap is for fedora, dude"
  exit 1
fi

sudo dnf update -y

sudo dnf install -y ansible git python3 python3-pip


if [ -d ~/Projects/github/dotfiles ]; then
  echo "Deleting dotfiles..."
  rm -rf ~/Projects/github/dotfiles
fi

mkdir -p ~/Projects/github/
git clone https://github.com/lennox-davidlevy/dotfiles.git -b fedora ~/Projects/github/dotfiles

cd ~/Projects/github/dotfiles

ansible-playbook playbooks/bootstrap.yml


kill $SUDO_PID 2>/dev/null || true
