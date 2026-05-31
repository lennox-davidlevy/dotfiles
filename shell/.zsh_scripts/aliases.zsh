# General
alias vim=nvim
alias kb=kubectl
alias dk=docker
alias pd=podman
alias ic="ibmcloud"
alias open="xdg-open"

unalias ls ll la lt lsa 2>/dev/null

# Modern eza if installed, otherwise fallback to standard ls
if command -v eza &> /dev/null; then
  ls() { eza --icons "$@" }
  ll() { eza -lah --icons "$@" }
  la() { eza -a --icons "$@" }
  lt() { eza --tree --icons "$@" }
else
  alias ls="ls --color=auto"
  alias ll="ls -lah"
  alias la="ls -a"
fi

# Docker
alias dia="docker image ls | bat"
alias dca="docker ps -a | bat"
alias dc="docker ps | bat"
alias dr="docker run"
alias drs="docker restart"
alias de="docker exec -it"
alias ds="docker stop"
alias dre="docker rm"
alias dire="docker image rm"
alias dsp="docker system prune"

alias docker-compose="docker compose"

alias pia="podman image ls | bat"

# Podman
alias pdstart="podman machine start"
alias pdstop="podman machine stop"
alias pia="podman image ls | bat"
alias pca="podman ps -a | bat"
alias pc="podman ps | bat"
alias pire="podman image rm"
alias psp="podman system prune"

# alias tree="tree -C -I node_modules | less"
alias tree="tree -L 3 -C -I 'node_modules|__pycache__'"

# Typescript
alias ts=ts-node

# VI in line
alias setvi="set -o vi"

# layout tmux panes nicely for dev
alias dl="devlayout"
