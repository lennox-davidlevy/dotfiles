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

# === Autocomplete ===
autoload -Uz compinit && compinit -C

# === PATH Configuration ===
# Detect architecture and set Homebrew path
if [[ "$(uname -m)" == "arm64" ]]; then
  export BREW_PREFIX="/opt/homebrew"
else
  export BREW_PREFIX="/usr/local"
fi

# Add Homebrew to PATH
eval "$($BREW_PREFIX/bin/brew shellenv)"

# User binaries
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

# === Environment Variables ===
export EDITOR=nvim
export SYSTEMD_EDITOR=nvim

# === Python Environment Manager (pyenv) ===
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - zsh)"
fi

# === Node Version Manager (fnm) ===
# FNM_PATH="$HOME/.local/share/fnm"
# if [ -d "$FNM_PATH" ]; then
#   export PATH="$FNM_PATH:$PATH"
#   eval "$(fnm env --use-on-cd --shell zsh)"
#   eval "$(fnm completions --shell zsh)"
# fi
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

# === Theme ===
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# === Custom Scripts ===
[ -f ~/.zsh_scripts/tmux-autostart.zsh ] && source ~/.zsh_scripts/tmux-autostart.zsh
[ -f ~/.zsh_scripts/aliases.zsh ] && source ~/.zsh_scripts/aliases.zsh
[ -f ~/.zsh_scripts/functions.zsh ] && source ~/.zsh_scripts/functions.zsh
# [ -f ~/.zsh_scripts/secrets.zsh ] && source ~/.zsh_scripts/secrets.zsh

# === Environment Directories ===
[ -f ~/.env_directories ] && source ~/.env_directories

# === Ollama setup ===
# macOS default location (customize as needed)
# export OLLAMA_MODELS="$HOME/.ollama/models"

# === Additional Tools ===
# UV (Python package installer)
if command -v uv &> /dev/null; then
  eval "$(uv generate-shell-completion zsh)"
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

# Added by Antigravity
export PATH="/Users/davidlevy/.antigravity/antigravity/bin:$PATH"
