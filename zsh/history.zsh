#!/bin/bash
set -e

# Create history directory if it doesn't exist
# This assumes a volume mount at /commandhistory (configured in devcontainer)
HISTORY_DIR="${HISTORY_DIR:-/commandhistory}"
HISTORY_FILE="$HISTORY_DIR/.zsh_history"

# Create directory if it doesn't exist (will be created on first run)
mkdir -p "$HISTORY_DIR" 2>/dev/null || true

# Configure zsh history settings
if [ -f "$HOME/.zshrc" ]; then
    # Check if history config already exists
    if ! grep -q "# Dotfiles history config" "$HOME/.zshrc" 2>/dev/null; then
        echo "  Configuring persistent shell history..."
        cat >> "$HOME/.zshrc" << 'EOF'

# Dotfiles history config
export HISTFILE="$HISTORY_DIR/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt SHARE_HISTORY          # Share history between all sessions
setopt HIST_IGNORE_DUPS       # Don't record duplicate entries
setopt HIST_IGNORE_ALL_DUPS   # Remove old duplicate entries
setopt HIST_FIND_NO_DUPS      # Don't display duplicates when searching
setopt HIST_IGNORE_SPACE      # Don't record commands starting with space
setopt HIST_VERIFY            # Show command with history expansion before running
setopt APPEND_HISTORY         # Append to history file, don't overwrite
EOF
    fi
fi

