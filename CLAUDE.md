# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Dotfiles repo for Cursor/VS Code devcontainer environments. Cloned automatically by the IDE into `~/dotfiles` and executed via `install.sh` on container start.

## Architecture

- `install.sh` — Main entrypoint. Runs all setup steps sequentially: oh-my-zsh plugins, history config, Claude Code install, then custom zsh config. All steps are idempotent (guard checks before modifying).
- `zsh/plugins.zsh` — Clones oh-my-zsh plugins (autosuggestions, syntax-highlighting, you-should-use) and enables them in `.zshrc` via sed.
- `zsh/history.zsh` — Configures persistent zsh history at `/commandhistory/.zsh_history` (expects a Docker volume mount).
- `.zshrc` — Custom aliases and functions appended to the user's `.zshrc` under a `# Dotfiles custom config` sentinel comment.

## Key Patterns

- **Idempotency**: Every script checks whether its work has already been done before modifying anything (directory existence, grep for sentinel comments, `command -v` checks). New scripts must follow this pattern.
- **Append-only .zshrc**: Custom config is appended to the existing oh-my-zsh `.zshrc`, never overwritten. Sentinel comments (`# Dotfiles custom config`, `# Dotfiles history config`) prevent duplicate appends.
- **Fail-safe**: Scripts use `set -e` but guard potentially-failing commands with `|| true` to avoid aborting the full install on non-critical failures.
- **No macOS sed**: `zsh/plugins.zsh` uses `sed -i` (GNU style, no backup extension) — these scripts target Linux devcontainers, not macOS directly.

## Running

```bash
./install.sh    # Run the full install (idempotent)
```
