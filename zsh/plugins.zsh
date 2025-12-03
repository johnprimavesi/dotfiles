#!/bin/bash
set -e

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "  Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true
fi

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "  Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true
fi

# Update plugins in .zshrc if not already present
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "zsh-autosuggestions\|zsh-syntax-highlighting" "$HOME/.zshrc"; then
        echo "  Enabling plugins in .zshrc..."
        # Use sed to add plugins, handling both single-line and multi-line plugin declarations
        sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc" 2>/dev/null || \
        sed -i 's/plugins=([^)]*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc" 2>/dev/null || true
    fi
fi

