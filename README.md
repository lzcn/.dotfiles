# Personal Dotfiles

Dotfiles for macOS and Linux, managed with GNU Make.

## Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lzcn/.dotfiles/master/install.sh)" -- bootstrap
```

Installs prerequisites and Homebrew, clones into `~/.dotfiles`, and runs `make all`.

<details>
<summary>Manual install</summary>

```bash
git clone https://github.com/lzcn/.dotfiles.git
cd ~/.dotfiles
make all
```

</details>

## Update

```bash
dots-update   # or: make update
```

Pulls this repo (and `~/.tmux`, `~/.gitalias`, `~/Library/Rime` if present), then updates Homebrew packages/apps, Zinit plugins, and Neovim plugins. It never runs setup or compiles Swift — use `make install` after adding to `Brewfile`.

- `--light` — Git repos only
- `--no-brew` / `--no-zinit` / `--no-git` / `--no-nvim` — skip a component
- `--snippets` — also refresh snippets declared in `.zshrc` (skipped by default)
- `--proxy` / `--no-proxy` — use `PROXY_HOST`/`PROXY_HTTP_PORT`/`PROXY_SOCKS_PORT` or clear proxy vars; otherwise the current proxy is inherited
- failed components are reported but don't stop the rest; see `dots-update --help` for details

## Components

Run from `~/.dotfiles`.

| Command | Links | Notes |
| --- | --- | --- |
| `make zsh` | [`zsh/.zshrc`](zsh/.zshrc), [`zsh/.p10k.zsh`](zsh/.p10k.zsh) | See [Zsh](#zsh) below |
| `make nvim` | [`nvim/`](nvim/) → `~/.config/nvim` | Config in [`nvim/lua/config/`](nvim/lua/config/), plugins in [`nvim/lua/plugins/`](nvim/lua/plugins/) |
| `make tmux` | [`tmux/.tmux.conf.local`](tmux/.tmux.conf.local) → `~/.tmux.conf.local` | Installs Oh My Tmux if needed |
| `make git` | [`git/.gitconfig`](git/.gitconfig) → `~/.gitconfig` | Initializes Git LFS if installed |
| `make atuin` | [`atuin/config.toml`](atuin/config.toml) → `~/.config/atuin/config.toml` | Shell history search |
| `make swift` | [`swift/`](swift/) → `~/.local/bin` | Rebuilds only missing/changed binaries; skipped on update |

### Zsh

- `~/.zshenv` — machine-local paths and overrides; edit outside the managed block
- `~/.config/zsh/secrets.zsh` — API keys and tokens; private and untracked
- Setup auto-detects Homebrew/Conda; override with `DOTFILES_HOMEBREW_PREFIX` / `DOTFILES_CONDA_ROOT`
- Set `CONDA_DEFAULT_START_ENV` in `~/.zshenv` to auto-activate an environment
- `proxy on` / `proxy off` / `proxy` — toggle or inspect the shell proxy (configure via `PROXY_HOST`, `PROXY_HTTP_PORT`, `PROXY_SOCKS_PORT`)
- Scripts are formatted with `beautysh` (`<leader>cf` in Neovim)

**Key bindings**

| Key | Action |
| --- | --- |
| `Alt+p` / `Alt+n` | Walk history |
| `Alt+f` / `Alt+b` | Move by word |
| `Ctrl-R` | Multi-word history search |
| `Ctrl-X Ctrl-R` | Open Atuin |
| `Ctrl-T` / `Alt-C` | Fuzzy-select files / directories |

### Tmux

Prefix is `C-a`; `C-a C-a` sends a literal `C-a`.

| Key | Action |
| --- | --- |
| `prefix \|` / `prefix -` | Split pane right / below |
| `prefix C-s` | Toggle synchronize-panes |
| `prefix m` | Toggle mouse mode |
| `prefix e` / `prefix r` | Edit / reload this config |

Escape delay, focus events, true color, undercurl, and cursor shapes are configured so Neovim behaves the same inside tmux as outside.

## Maintenance

| Command | Purpose |
| --- | --- |
| `make help` | List all targets (default) |
| `make all` | `install` + `setup` + `check` |
| `make install` | Install Homebrew packages and Zinit |
| `make setup` | Configure all components; back up conflicting files |
| `make update` / `dots-update` | Update software, plugins, and dotfiles |
| `make check` | Lint shell scripts, `.gitconfig`, `Brewfile`, and `README.md` |

`Makefile` is the entry point: `install.sh` installs dependencies, `setup.sh` applies configuration. Each component can also be run individually, e.g. `make zsh`.
