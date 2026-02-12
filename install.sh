#!/bin/bash
set -e

echo "🚀 Installing dotfiles..."

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Helper: run with sudo if available, otherwise run directly (devcontainers often run as root)
run_pkg() {
    if command -v sudo &> /dev/null; then
        sudo "$@"
    else
        "$@"
    fi
}

# Install essential tools (curl, git, zsh) if missing
install_packages() {
    local packages=()
    command -v curl &> /dev/null || packages+=(curl)
    command -v git &> /dev/null || packages+=(git)
    command -v zsh &> /dev/null || packages+=(zsh)

    if [ ${#packages[@]} -eq 0 ]; then
        echo "🐚 curl, git, zsh already installed"
        return
    fi

    echo "📦 Installing missing packages: ${packages[*]}..."
    if command -v apt-get &> /dev/null; then
        run_pkg apt-get update && run_pkg apt-get install -y "${packages[@]}"
    elif command -v yum &> /dev/null; then
        run_pkg yum install -y "${packages[@]}"
    elif command -v apk &> /dev/null; then
        apk add --no-cache "${packages[@]}"
    else
        echo "⚠️  Could not install packages: unsupported package manager"
    fi
}

install_packages

# Install oh-my-zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🎨 Installing oh-my-zsh..."
    if command -v curl &> /dev/null; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    elif command -v wget &> /dev/null; then
        sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "⚠️  Could not install oh-my-zsh: curl or wget required"
    fi
else
    echo "🎨 oh-my-zsh already installed"
fi

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
    TERM=dumb CI=true curl -fsSL https://claude.ai/install.sh | TERM=dumb CI=true bash
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

