#!/usr/bin/env bash
set -euo pipefail

echo "lets start again cause we be testing..."

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

remove_packages "ansible" "git" "python3" "python3-pip"

echo "clean up"
sudo dnf autoremove -y

echo "teardown done bro"
