# Dotfiles Repository

Personal development environment configurations for Cursor/VS Code devcontainers.

## What's Included

- **Oh-my-zsh plugins**: zsh-autosuggestions and zsh-syntax-highlighting
- **Persistent shell history**: Command history persists across container rebuilds
- **Git completions**: Enhanced tab completions for git commands
- **Custom shell configuration**: Personal aliases and functions

## Setup

### Option 1: Use This Repository As-Is

Simply configure Cursor/VS Code to use this repository directly.

### Option 2: Fork and Customise

1. Fork this repository on GitHub (click the "Fork" button)
2. Customise the configuration files as needed
3. Use your forked repository URL in the configuration below, make sure it's public.

### Configure Cursor/VS Code

Add to your Cursor/VS Code **User Settings** (not workspace settings):

**Via Settings UI:**
- Open Settings (`Ctrl+,` or `Cmd+,`)
- Search for "dotfiles"
- Set "Dotfiles: Repository" to either:
  - `johnprimavesi/dotfiles` (to use this repo as-is), or
  - `yourusername/dotfiles` (if you forked it)
- Set "Dotfiles: Target Path" to `~/dotfiles`
- Set "Dotfiles: Install Command" to `install.sh`

**Via settings.json:**
```json
{
    "dotfiles.repository": "johnprimavesi/dotfiles",
    "dotfiles.targetPath": "~/dotfiles",
    "dotfiles.installCommand": "install.sh"
}
```

(Replace `johnprimavesi/dotfiles` with your forked repository if you chose Option 2)

### 2. Configure Devcontainer for History Persistence

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

### 3. Rebuild Devcontainer

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

