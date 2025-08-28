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

# Options
setopt autocd
unsetopt beep extendedglob
bindkey -v

# === Completion System ===
zstyle :compinstall filename '/home/david/.zshrc'
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# === PATH Configuration ===
export PATH="$HOME/.local/bin:$PATH"
export PATH="/home/david/bin:$PATH"
export PATH="/home/david/.opencode/bin:$PATH"
export PATH="/opt/zig:$PATH"

# === Environment Variables ===
export EDITOR=nvim

# === Python Environment Manager (pyenv) ===
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - zsh)"
fi

# === Node Version Manager (fnm) ===
FNM_PATH="/home/david/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/david/.local/share/fnm:$PATH"
  eval "$(fnm env --use-on-cd --shell zsh)"
  eval "$(fnm completions --shell zsh)"
fi

# === Bun ===
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "/home/david/.bun/_bun" ] && source "/home/david/.bun/_bun"

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

# === Environment Directories ===
[ -f ~/.env_directories ] && source ~/.env_directories
