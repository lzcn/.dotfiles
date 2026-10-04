# Personal Dotfiles

macOS and Linux configuration, managed with GNU Make.

## Install

On a fresh machine:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lzcn/.dotfiles/master/install.sh)" -- bootstrap
```

This installs prerequisites, clones the repo to `~/.dotfiles`, and runs `make install`.

For an existing machine:

```bash
git clone https://github.com/lzcn/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles && make install
```

## Update

```bash
dots-update
```

With no targets, only configuration Git repos are updated. Explicit targets
replace this default; they do not add to it:

```bash
dots-update brew          # Homebrew only
dots-update git nvim      # Configuration repos and Neovim
dots-update all           # All installed components, including Zsh snippets
dots-update all --dry-run # Inspect the plan without updating anything
```

Targets: `git`, `brew`, `zinit`, `nvim`, `snippets`, `all`. `make update` uses the
default. Repos with local changes are skipped; Git updates use fast-forward only.
Run `dots-update --help` for details and `make setup` to apply configuration.

## Utilities

- `tmux-kill-idle --dry-run`: list idle detached sessions. Active processes and
  attached sessions are kept. Use `tmux set-option -t SESSION @keep 1` to protect
  a session explicitly.
- `active-users [WTMP]`: report recorded login activity.
- `intruder-detect [AUTH_LOG]`: report failed SSH password attempts.

All commands support `--help`. Log and tmux utilities require Python 3.9+.

## Commands

| Command | Purpose |
| --- | --- |
| `make install` | Install dependencies, apply configuration, and check |
| `make setup` | Apply configuration and back up conflicts |
| `make update` | Update configuration Git repos |
| `make check` | Check syntax and configuration |

For a single component, use `./setup.sh --yes zsh` (or `nvim`, `tmux`, `kitty`,
`git`, `atuin`, `swift`). See [`lazyvim/manual.md`](lazyvim/manual.md) for Neovim.

## Shortcuts

| Shortcut | Action |
| --- | --- |
| `Ctrl-R` | Search Atuin history |
| `Ctrl-X Ctrl-R` | Multi-word shell history search |
| `Ctrl-T` / `Alt-C` | Select files / directories with `fzf` |
| `C-a \|` / `C-a -` | Split a Tmux pane |

For local settings, edit `~/.zshenv`. Secrets belong in `~/.config/zsh/secrets.zsh`; setup creates it with private permissions.
