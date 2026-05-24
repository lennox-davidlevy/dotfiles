# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# === Oh My Zsh ===
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# === Shell Configuration ===
# History
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# === Options ===
setopt autocd
unsetopt beep extendedglob
bindkey -v

# === Completion System ===
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit && compinit -C
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# === PATH Configuration ===
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
[[ -d /opt/zig ]] && export PATH="/opt/zig:$PATH"

# === Environment Variables ===
export EDITOR=nvim
export SYSTEMD_EDITOR=nvim
export KUBE_EDITOR='nvim'
export OPENCODE_ENABLE_EXA=1
export OPENCODE_DISABLE_CLAUDE_CODE=1

# === Python Environment Manager (pyenv) ===
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - zsh)"
fi

# === Node Version Manager (fnm) ===
if command -v fnm &> /dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
  eval "$(fnm completions --shell zsh)"
fi

# === Bun ===
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# === Go ===
if [[ -d /usr/local/go/bin ]]; then
  export PATH="$PATH:/usr/local/go/bin"
fi
# User binaries installed via `go install` (defaults to ~/go/bin)
export GOPATH="${GOPATH:-$HOME/go}"
if [[ -d "$GOPATH/bin" ]]; then
  export PATH="$GOPATH/bin:$PATH"
fi

# === Theme ===
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# === p10k overrides (survive `p10k configure` regenerations) ===
# Show kubecontext continuously when a context is active (covers `oc login`).
# unset POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND
# Tag OpenShift-shaped contexts (oc login writes <ns>/<api-host>:<port>/<user>).
typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
    '*/api-*:*/*'  OPENSHIFT
    '*:6443/*'     OPENSHIFT
    '*'            DEFAULT)
# OpenShift visual identifier (nf-fa-redhat, U+EF5D).
typeset -g POWERLEVEL9K_KUBECONTEXT_OPENSHIFT_VISUAL_IDENTIFIER_EXPANSION=''
# Concise content: "<short-cluster>/<namespace>" e.g. "argocd3/vault-verify".
typeset -g POWERLEVEL9K_KUBECONTEXT_OPENSHIFT_CONTENT_EXPANSION='${${${P9K_KUBECONTEXT_CLUSTER#api-}%%:*}%%-*}/${P9K_KUBECONTEXT_NAMESPACE}'

# === Custom Scripts ===
[ -f ~/.zsh_scripts/tmux-autostart.zsh ] && source ~/.zsh_scripts/tmux-autostart.zsh
[ -f ~/.zsh_scripts/aliases.zsh ] && source ~/.zsh_scripts/aliases.zsh
[ -f ~/.zsh_scripts/functions.zsh ] && source ~/.zsh_scripts/functions.zsh
# [ -f ~/.zsh_scripts/secrets.zsh ] && source ~/.zsh_scripts/secrets.zsh

# === Environment Directories ===
[ -f ~/.env_directories ] && source ~/.env_directories

# === Ollama setup ===
export OLLAMA_MODELS=/mnt/fast-nvme-2t/ollama/models

# === Additional Tools ===
# UV (Python package installer)
if command -v uv &> /dev/null; then
  eval "$(uv generate-shell-completion zsh)"
fi

# oc autocomplete
if [ $commands[oc] ]; then
  source <(oc completion zsh)
  compdef _oc oc
fi

# kubectl autocomplete
if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
  compdef _kubectl kubectl
fi

# Zoxide (smarter cd)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# FZF (fuzzy finder)
if command -v fzf &> /dev/null; then
  eval "$(fzf --zsh)"
fi

autoload -U +X bashcompinit && bashcompinit

# Nomad autocomplete
if command -v nomad &> /dev/null; then
  complete -o nospace -C "$(command -v nomad)" nomad
fi

# Vault autocomplete (HashiCorp Vault CLI)
# https://developer.hashicorp.com/vault/docs/commands#enable-autocomplete
if command -v vault &> /dev/null; then
  complete -o nospace -C "$(command -v vault)" vault
fi

fpath+=~/.zfunc
