# Personal Dotfiles

macOS and Linux dotfiles for Zsh, tmux, Kitty, and Neovim.

## Install

Run:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lzcn/.dotfiles/master/install.sh)" -- bootstrap
```

This prepares dependencies, clones the repo to `~/.dotfiles`, and applies the configuration. Conflicting files are backed up. Open a new Zsh session afterward.

## Maintenance

```bash
dots-update all # Update configs, tools, and plugins
make setup      # Apply configuration
make check      # Check configuration
```

## Local settings

Edit `~/.zshenv`; keep secrets in `~/.config/zsh/secrets.zsh`.

- `CONDA_DEFAULT_START_ENV=name`: activate `name` in new interactive shells. Unset or empty uses `base`.
- `PROXY_HOST`, `PROXY_HTTP_PORT`, `PROXY_SOCKS_PORT`: proxy endpoints. Use `proxy on`, `proxy off`, or `proxy status`; activation is manual.
- `_evalcache_clear`: refresh cached tool initialization on the next shell startup.

## Shortcuts

| Shortcut           | Action                                    |
| ------------------ | ----------------------------------------- |
| `Ctrl-R`           | Search Atuin history                      |
| `Tab`              | Complete commands and paths               |
| `Ctrl-X Ctrl-R`    | Multi-word shell history search           |
| `Ctrl-T` / `Alt-C` | Select files / directories with `fzf`     |
| `C-a \|` / `C-a -` | Split a Tmux pane                         |
| `C-a r` / `C-a u`  | Reload Tmux / update Tmux plugins         |
| `Ctrl-Shift-F5`    | Reload Kitty                              |
