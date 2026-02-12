#!/bin/bash
set -e

echo "🚀 Installing dotfiles..."

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install oh-my-zsh plugins
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Installing oh-my-zsh plugins..."
    "$DOTFILES_DIR/zsh/plugins.zsh"
fi

# Configure zsh history persistence
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "📜 Configuring shell history persistence..."
    "$DOTFILES_DIR/zsh/history.zsh"
fi

# Install Claude Code
if ! command -v claude &> /dev/null; then
    echo "🤖 Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "🤖 Claude Code already installed"
fi

# Link or source custom .zshrc additions
if [ -f "$DOTFILES_DIR/.zshrc" ]; then
    echo "⚙️  Applying custom zsh configuration..."
    # Append custom config to existing .zshrc (don't overwrite oh-my-zsh's base config)
    if ! grep -q "# Dotfiles custom config" "$HOME/.zshrc" 2>/dev/null; then
        echo "" >> "$HOME/.zshrc"
        echo "# Dotfiles custom config" >> "$HOME/.zshrc"
        cat "$DOTFILES_DIR/.zshrc" >> "$HOME/.zshrc"
    fi
fi

echo "✅ Dotfiles installation complete!"

