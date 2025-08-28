#!/usr/bin/env zsh

# Auto-start or attach to UTILS tmux session

# Only run in interactive shells
if [[ $- != *i* ]]; then
    return 0
fi

# Check if we're already inside a tmux session
if [[ -n "$TMUX" ]]; then
    return 0
fi

# Check if tmux is available
if ! command -v tmux &> /dev/null; then
    return 0
fi

# Check if we have a proper terminal (stdin and stdout are terminals)
if [[ ! -t 0 || ! -t 1 ]]; then
    return 0
fi

# Skip if this is a login shell from SSH without a display
if [[ -n "$SSH_CONNECTION" && -z "$DISPLAY" && "$SHLVL" -eq 1 ]]; then
    return 0
fi

# Check if UTILS session exists
if tmux has-session -t UTILS 2>/dev/null; then
    # Session exists, attach to it
    echo "Attaching to existing UTILS tmux session..."
    exec tmux attach-session -t UTILS
else
    # Session doesn't exist, create it
    echo "Creating new UTILS tmux session..."
    exec tmux new-session -s UTILS
fi
