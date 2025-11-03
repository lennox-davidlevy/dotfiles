# add an env to the directory you are currently in
function addenv() {
  local dirpath="$(pwd)"
  local varname

  if grep -Fq "'$dirpath'" ~/.env_directories 2>/dev/null; then
    echo "The directory '$dirpath' is already associated with a variable in .env_directories."
    grep "'$dirpath'" ~/.env_directories
    return 1
  fi

  read "varname?Enter variable name: "

  if grep -Eq "^export $varname=" ~/.env_directories 2>/dev/null; then
    echo "The variable name '$varname' is already used in .env_directories."
    grep "^export $varname=" ~/.env_directories
    read -q "overwrite?Do you want to overwrite it? (y/n): "
    echo
    if [[ ! $overwrite =~ ^[Yy]$ ]]; then
      echo "Operation cancelled."
      return 1
    else
      sed -i.bak "/^export $varname=/d" ~/.env_directories
      echo "Previous entry for '$varname' removed."
    fi
  fi

  echo "export $varname='$dirpath'" >>~/.env_directories
  source ~/.env_directories
  echo "Added and sourced: export $varname='$dirpath'"
}

# function to create a new pyenv virtual environment
function vmake {
  if [ -z "$1" ]; then
    echo "Usage: create_pyenv_virtualenv <env_name> [python_version]"
    return 1
  fi

  local env_name=$1
  local python_version=${2:-$(pyenv global)}

  if pyenv versions --bare | grep -q "^${env_name}$"; then
    echo "Virtual environment '${env_name}' already exists."
    return 1
  fi

  pyenv virtualenv ${python_version} ${env_name}

  if [ $? -eq 0 ]; then
    echo "Virtual environment '${env_name}' created successfully."
  else
    echo "Failed to create virtual environment '${env_name}'."
    return 1
  fi
}

# Function to delete a pyenv virtual environment
function vdel {
  if [ -z "$1" ]; then
    echo "Usage: venv_del <env_name>"
    return 1
  fi

  local env_name=$1

  if ! pyenv versions --bare | grep -q "^${env_name}$"; then
    echo "Environment '${env_name}' does not exist."
    return 1
  fi

  pyenv uninstall -f ${env_name}

  if [ $? -eq 0 ]; then
    echo "Environment '${env_name}' deleted successfully."
  else
    echo "Failed to delete environment '${env_name}'."
    return 1
  fi
}

# Function to list all pyenv virtual environments
function vlist {
  pyenv virtualenvs
}

function vstart {
  if [ -z "$1" ]; then
    echo "Usage: vstart <env_name>"
    return 1
  fi
  local env_name=$1

  # Activate the environment
  init_pyenv_virtualenv
  pyenv activate "$env_name"

  # Check if activation was successful
  if [ $? -eq 0 ]; then
    echo "Activated environment '$env_name'. Restarting shell..."
    exec $SHELL
  else
    echo "Failed to activate environment '$env_name'."
    return 1
  fi
}

# Function to deactivate current virtual environment
function vstop {
  pyenv deactivate
}

# Function to initialize pyenv virtualenv when needed
function init_pyenv_virtualenv {
  if [ -z "$PYENV_VIRTUALENV_INIT" ]; then
    eval "$(pyenv virtualenv-init -)"
    export PYENV_VIRTUALENV_INIT=1
  fi
}

# SSH nonsense
ssh() {
  if [[ -n "$TMUX" ]]; then
    # tmux select-pane -P 'bg=#054ADA,fg=white'
    # tmux select-pane -P 'bg=black,fg=green'
    tmux select-pane -P 'bg=black,fg=colour46'
    command ssh "$@"
    tmux select-pane -P 'bg=default,fg=default'
  else
    command ssh "$@"
  fi
}

# Copy public url to clipboard after starting ngrok
ngrokpb() {
  (
    sleep 2
    curl -s http://127.0.0.1:4040/api/tunnels |
      jq -r '.tunnels[0].public_url' |
      tr -d '\n' |
      pbcopy
    echo "Copied: $(pbpaste)"
  ) &

  ngrok http "${1:-8000}"
}

# Open remote repo from cli
remote-open() {
  local remote=${1:-origin}

  local url=$(git remote get-url "$remote" 2>/dev/null)

  if [[ -z "$url" ]]; then
    echo "Error: Remote '$remote' not found"
    echo "Available remotes:"
    git remote -v
    return 1
  fi

  if [[ "$url" =~ ^git@(.+):(.+)\.git$ ]]; then
    url="https://${match[1]}/${match[2]}"
  elif [[ "$url" =~ ^git@(.+):(.+)$ ]]; then
    url="https://${match[1]}/${match[2]}"
  fi

  url=${url%.git}

  echo "Opening: $url"
  open "$url" # macOS
  # Use 'xdg-open "$url"' for Linux
}

remote-copy() {
  local remote=${1:-origin}
  local url

  url=$(git remote get-url "$remote" 2>/dev/null) || {
    echo "Error: Remote '$remote' not found" >&2
    echo "Available remotes:" >&2
    git remote -v
    return 1
  }

  if [[ $url =~ ^git@([^:]+):(.+)\.git$ ]]; then
    url="https://${match[1]}/${match[2]}.git"
  fi

  echo "Copying: $url"
  printf '%s' "$url" | pbcopy
}

# Open remote repo from cli
fast-docs() {
  PORT="${1:-${FASTAPI_PORT:-8000}}"
  URL="http://127.0.0.1:${PORT}/docs"
  open "$URL"
}

# File preview with fzf and bat
fp() {
  local file
  if [[ $# -eq 0 ]]; then
    file=$(find . -type f | fzf --preview 'bat --color=always {}')
  else
    file=$(find . -name "*$1*" -type f | fzf --preview 'bat --color=always {}')
  fi
  
  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}
