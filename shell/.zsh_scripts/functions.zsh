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
  local use_ssh=${2:-false}
  local url
  local original_url

  url=$(git remote get-url "$remote" 2>/dev/null) || {
    echo "Error: Remote '$remote' not found" >&2
    echo "Available remotes:" >&2
    git remote -v
    return 1
  }

  original_url="$url"

  if [[ $use_ssh == "true" ]]; then
    if [[ $url =~ ^https://([^/]+)/(.+)\.git$ ]]; then
      url="git@${match[1]}:${match[2]}.git"
    elif [[ $url =~ ^https://([^/]+)/(.+)$ ]]; then
      url="git@${match[1]}:${match[2]}"
    fi
  else
    if [[ $url =~ ^git@([^:]+):(.+)\.git$ ]]; then
      url="https://${match[1]}/${match[2]}.git"
    fi
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

# Start colima with settings for orchestrate
function colima-orchestrate() {
  echo "Starting Colima with optimized settings for orchestrate..."
  colima start --cpu-type host --arch host --vm-type=vz --mount-type virtiofs -c 8 -m 16 "$@"
}

# Sign in and set secret environment values
function sign-in() {
  if command -v op &> /dev/null; then
    export BOBSHELL_API_KEY=$(op read "op://Private/Project Bob API key/credential" 2>/dev/null)
    echo "Signed in and BOBSHELL_API_KEY set."
    export TEST_API_KEY="hello"
    echo "Signed in and TEST_API_KEY set."
  else
    echo "op command not found."
  fi
}

# pick a kubeconfig from ~/.kube/configs and export it for this shell
function kubepick() {
  local configs_dir="$HOME/.kube/configs"

  if [[ ! -d "$configs_dir" ]]; then
    echo "No configs directory at $configs_dir"
    read -q "create?Create it now? (y/n): "
    echo
    [[ $create =~ ^[Yy]$ ]] && mkdir -p "$configs_dir" || return 1
  fi

  local files=("$configs_dir"/*.yaml(N) "$configs_dir"/*.yml(N))
  if (( ${#files} == 0 )); then
    echo "No kubeconfig files in $configs_dir"
    echo "Drop *.yaml files there (e.g. ocp-gym.yaml) and run again."
    return 1
  fi

  echo "Available kubeconfigs:"
  local i=1
  for f in $files; do
    local name="${f:t:r}"
    local marker=""
    [[ "$KUBECONFIG" == "$f" ]] && marker=" (current)"
    printf "  %d) %s%s\n" $i "$name" "$marker"
    ((i++))
  done

  local choice
  read "choice?Select [1-${#files}]: "
  if [[ ! "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#files} )); then
    echo "Invalid selection."
    return 1
  fi

  local selected="${files[$choice]}"
  export KUBECONFIG="$selected"
  echo "KUBECONFIG=$selected"

  if command -v kubectl >/dev/null 2>&1; then
    local ctx=$(kubectl config current-context 2>/dev/null)
    [[ -n "$ctx" ]] && echo "Current context: $ctx"
  fi
}

# unset KUBECONFIG (falls back to ~/.kube/config if present)
function kubeclear() {
  unset KUBECONFIG
  echo "KUBECONFIG unset (will fall back to ~/.kube/config if present)"
}

function envup() { set -a; source "${1:-.env}"; set +a; }

# Open a new tmux window with a 3-pane dev layout:
#   - left column: large top pane + ~20% height bottom pane
#   - right column: full-height pane, ~20% screen width
# Usage: devlayout [name] [start_dir]
function devlayout() {
  local name="${1:-DEV}"
  local start_dir="${2:-$PWD}"

  if [[ -z "$TMUX" ]]; then
    echo "Not inside a tmux session. Start tmux first, then run devlayout." >&2
    return 1
  fi

  # Create the new window and capture its id so splits target it reliably.
  local win
  win=$(tmux new-window -P -F '#{window_id}' -n "$name" -c "$start_dir") || return 1

  # Right pane: ~20% of the full width, spanning the full height.
  tmux split-window -h -p 30 -t "$win" -c "$start_dir"

  # Back on the left column, split off a ~20% height bottom pane.
  tmux select-pane -t "${win}.0"
  tmux split-window -v -p 25 -t "${win}.0" -c "$start_dir"

  # Leave focus on the large top-left pane.
  tmux select-pane -t "${win}.0"
}

# Run tree, strip ANSI color codes, and copy the clean output to the clipboard
function treecopy() {
  if ! command -v tree >/dev/null 2>&1; then
    echo "tree not found. Install it with: brew install tree" >&2
    return 1
  fi

  local output
  output=$(tree -n "$@" | sed $'s/\x1b\\[[0-9;]*[a-zA-Z]//g') || return $?

  printf '%s\n' "$output" | pbcopy
  printf '%s\n' "$output"
  echo "(copied to clipboard)"
}
