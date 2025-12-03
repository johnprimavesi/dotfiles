# Dotfiles Repository

Personal development environment configurations for Cursor/VS Code devcontainers.

## What's Included

- **Oh-my-zsh plugins**: zsh-autosuggestions and zsh-syntax-highlighting
- **Persistent shell history**: Command history persists across container rebuilds
- **Git completions**: Enhanced tab completions for git commands
- **Custom shell configuration**: Personal aliases and functions

## Setup

### 1. Create the Repository

1. Create a new GitHub repository (e.g., `yourusername/dotfiles`)
2. Clone it locally
3. Add the files from this plan

### 2. Configure Cursor/VS Code

Add to your Cursor/VS Code **User Settings** (not workspace settings):

**Via Settings UI:**
- Open Settings (`Ctrl+,` or `Cmd+,`)
- Search for "dotfiles"
- Set "Dotfiles: Repository" to your GitHub repo URL (e.g., `yourusername/dotfiles`)
- Set "Dotfiles: Target Path" to `~/dotfiles`
- Set "Dotfiles: Install Command" to `install.sh`

**Via settings.json:**
```json
{
    "dotfiles.repository": "yourusername/dotfiles",
    "dotfiles.targetPath": "~/dotfiles",
    "dotfiles.installCommand": "install.sh"
}
```

### 3. Configure Devcontainer for History Persistence

In your project's `.devcontainer/docker-compose.yml`, add a volume mount for history:

```yaml
services:
  dbt-shell:  # or your service name
    volumes:
      - commandhistory:/commandhistory

volumes:
  commandhistory:
```

Alternatively, mount a host directory:

```yaml
services:
  dbt-shell:
    volumes:
      - ~/.local/share/devcontainer-history:/commandhistory
```

### 4. Rebuild Devcontainer

After configuring:
1. Rebuild your devcontainer (`Dev Containers: Rebuild Container`)
2. Cursor/VS Code will automatically clone your dotfiles repo and run `install.sh`
3. Open a new terminal - you should see oh-my-zsh with plugins active
4. Test history persistence by running some commands, then rebuilding

## How It Works

1. **On devcontainer start**: Cursor/VS Code clones your dotfiles repo to `~/dotfiles`
2. **Automatic installation**: Cursor/VS Code runs `install.sh` from your repo
3. **Plugin installation**: Scripts install oh-my-zsh plugins
4. **History configuration**: Shell history is stored in a persistent volume
5. **Configuration applied**: Custom settings are added to `.zshrc`

## Troubleshooting

- **Plugins not working**: Open a new terminal (existing terminals don't reload .zshrc)
- **History not persisting**: Check that the volume mount is configured in docker-compose.yml
- **Install script not running**: Verify Cursor/VS Code dotfiles settings are in User Settings, not workspace

## Customization

Edit the files in this repo to customize:
- Add more plugins in `zsh/plugins.zsh`
- Add aliases/functions in `.zshrc`
- Adjust history settings in `zsh/history.zsh`

