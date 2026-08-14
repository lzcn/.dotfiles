# Personal Dotfiles

Configuration for my macOS setup. Managed via [GNU Make](https://www.gnu.org/software/make/).

## What's inside

| Dir | Purpose |
| --- | --- |
| `atuin/` | Atuin shell history search/sync config |
| `bin/` | Small daily-use scripts (on `PATH`) |
| `git/` | Git config, aliases, commit template, global gitignore |
| `nvim/` | Neovim config (LazyVim) + Lua tooling |
| `swift/` | Sources for compiled `bin/` tools |
| `tmux/` | Oh My Tmux config |
| `zsh/` | Zsh config powered by Zinit + Powerlevel10k |

## Quick start

```bash
git clone https://www.github.com/lzcn/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make all    # install deps → symlink configs → run validation
```

## Make targets

Run `make help` for the full list.

| Target | Description |
| --- | --- |
| `make install` | Install dependencies (Homebrew, Zinit) |
| `make setup` | Symlink config files into place |
| `make update` | `git pull --rebase` then re-apply symlinks |
| `make validate` | Syntax checks + shellcheck + git config sanity |
| `make all` | `install` → `setup` → `validate` |

### Individual components

`install.sh` accepts: `homebrew`, `zinit`, `all`
`setup.sh` accepts: `atuin`, `env`, `git`, `swift`, `nvim`, `zsh`, `all`

Both scripts accept multiple targets, e.g. `./setup.sh git zsh`.

## Manual prerequisites

- **Homebrew / conda prefixes** are written to `~/.zshenv` by `./setup.sh env`.
  If Homebrew isn't installed yet, install it first (see `make install`).
- Most CLI tools (e.g. `zoxide`) are installed separately; this repo only tracks
  *configuration*, not package lists.
- `tmux/` expects the Oh My Tmux base config; only `.tmux.conf.local` is tracked.
- `nvim/` requires LazyVim's bootstrap (handled by `init.lua`).

## Layout conventions

- `.luarc.json` / `.stylua.toml` live inside `nvim/` since they configure Lua tooling.
- Compiled Swift binaries in `bin/` are gitignored (built via `./setup.sh swift`).
- Nvim-local state (`lazy-lock.json`, `lazyvim.json`) is gitignored.
