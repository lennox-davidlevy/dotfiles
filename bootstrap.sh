#!/usr/bin/env bash
set -euo pipefail

if ! command -v dnf &> /dev/null; then
  echo "Error: this bootstap is for fedora"
  exit 1
fi

sudo dnf update -y

sudo dnf install -y ansible git python3 python3-pip
