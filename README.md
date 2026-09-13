# Personal Dotfiles

macOS and Linux configuration, managed with GNU Make.

## Install

On a fresh machine:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lzcn/.dotfiles/master/install.sh)" -- bootstrap
```

This installs prerequisites, clones the repo to `~/.dotfiles`, and runs `make all`.

For an existing machine:

```bash
git clone https://github.com/lzcn/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles && make all
```

## Update

```bash
dots-update
```

Updates dotfiles, Git repositories, Homebrew, Zinit, and Neovim. It does not run setup or compile Swift.

Common options:

```text
--light       Git repositories only
--no-brew     Skip Homebrew
--no-zinit    Skip Zinit
--no-git      Skip Git repositories
--no-nvim     Skip Neovim
--snippets    Update active Zsh snippets
```

Run `dots-update --help` for all options.

## Components

Run these from `~/.dotfiles`:

| Command | Purpose |
| --- | --- |
| `make zsh` | Zsh, Powerlevel10k, aliases, and keybindings |
| `make nvim` | Neovim configuration and plugins; see [`lazyvim/manual.md`](lazyvim/manual.md) |
| `make tmux` | Tmux configuration and Oh My Tmux |
| `make kitty` | Kitty terminal configuration |
| `make git` | Git configuration and Git LFS |
| `make atuin` | Atuin shell history |
| `make swift` | Build macOS Swift tools |

`make all` runs `install`, `setup`, and `check`.

## Shortcuts

| Shortcut | Action |
| --- | --- |
| `Ctrl-R` | Search shell history |
| `Ctrl-X Ctrl-R` | Search Atuin history |
| `Ctrl-T` / `Alt-C` | Select files / directories with `fzf` |
| `C-a \|` / `C-a -` | Split a Tmux pane |

For local settings, edit `~/.zshenv`. Secrets belong in `~/.config/zsh/secrets.zsh`; setup creates it with private permissions.

## Maintenance

| Command | Purpose |
| --- | --- |
| `make help` | List available targets |
| `make check` | Check shell syntax and configuration |
| `make setup` | Apply configuration and back up conflicts |
