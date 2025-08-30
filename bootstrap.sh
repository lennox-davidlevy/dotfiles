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

mkdir -p ~/Projects/github/
git clone https://github.com/lennox-davidlevy/dotfiles.git -b fedora ~/Projects/github/dotfiles

kill $SUDO_PID 2>/dev/null || true
