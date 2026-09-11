# Personal Dotfiles

Dotfiles for macOS and Ubuntu, managed with GNU Make.

## Install

On a fresh macOS or Ubuntu machine (requires Bash and curl):

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/lzcn/.dotfiles/master/install.sh)" -- bootstrap
```

Bootstrap installs prerequisites and Homebrew, clones into `~/.dotfiles`, and
runs `make all`. System installers may request sudo or Command Line Tools.
If curl is missing on Ubuntu, install it with `sudo apt-get update && sudo apt-get install -y curl`.

For an existing checkout:

```bash
make all
```

This installs [`Brewfile`](Brewfile) dependencies, configures components, and
checks the result. Existing configuration is backed up; reruns are supported.
Open a new Zsh session afterward. Conda environments and API keys are machine-local
and are not installed automatically.

## Update

```bash
dots-update
# Or, from ~/.dotfiles:
make update
```

Updates dotfiles, installed Homebrew packages/apps, Zinit, and Neovim plugins.
Run `make install` or `make all` to install new Brewfile dependencies.
Updates do not run setup or compile Swift.
Use `--no-nvim`, `--no-brew`, `--no-zinit`, or `--no-git` to skip a component.
The current proxy is inherited. Failed components are summarized at the end.
Zinit updates Git plugins by default; `dots-update --snippets` also refreshes
the snippets declared in `.zshrc`, excluding old unused snippets.

## Components

Run the setup commands below from `~/.dotfiles`.

### Zsh

```bash
make zsh
```

- [`zsh/.zshrc`](zsh/.zshrc): Zinit plugins, aliases, and keybindings.
- [`zsh/.p10k.zsh`](zsh/.p10k.zsh): Powerlevel10k prompt.
- `~/.zshenv`: machine-local paths and overrides; edit outside the managed block.
- `~/.config/zsh/secrets.zsh`: API keys and tokens; private and untracked.

Setup detects Homebrew and Conda locations. For custom paths, set
`DOTFILES_HOMEBREW_PREFIX` or `DOTFILES_CONDA_ROOT` when running setup.
Set `CONDA_DEFAULT_START_ENV` in `~/.zshenv` to activate an environment on startup.
Use `proxy on`, `proxy off`, or `proxy` to toggle or inspect the shell proxy;
set `PROXY_HOST`, `PROXY_HTTP_PORT`, and `PROXY_SOCKS_PORT` in `~/.zshenv`.

Key bindings: Alt+p / Alt+n walk history, Alt+f / Alt+b move by word; Ctrl-R
searches history with Atuin. P10k preserves full prompts in scrollback and
shows failed exit codes, background job counts, active Python environments,
and durations over 3 seconds. Zsh scripts are formatted with `beautysh`
(`<leader>cf` in Neovim).

For CJK text on macOS, run `brew install --cask font-sarasa-gothic` and select
the "Sarasa Term SC Nerd" font in the terminal app.

### Neovim

```bash
make nvim
```

Links [`nvim/`](nvim/) to `~/.config/nvim`.
Edit [`nvim/lua/config/`](nvim/lua/config/) for options and keybindings,
and [`nvim/lua/plugins/`](nvim/lua/plugins/) for plugins.

### Tmux

```bash
make tmux
```

Installs Oh My Tmux if needed. Customize
[`tmux/.tmux.conf.local`](tmux/.tmux.conf.local), linked to `~/.tmux.conf.local`.

Prefix is `C-a`; `C-a C-a` sends a literal `C-a`.

| Key | Action |
| --- | --- |
| `prefix \|` / `prefix -` | Split pane right / below |
| `prefix C-s` | Toggle synchronize-panes |
| `prefix m` | Toggle mouse mode |
| `prefix e` / `prefix r` | Edit / reload this config |

Escape delay, focus events, true color, undercurl, and cursor shapes are
configured, so Neovim behaves the same inside tmux as outside.

### Git

```bash
make git
```

Links [`git/.gitconfig`](git/.gitconfig) to `~/.gitconfig`
and initializes Git LFS if installed.

### Atuin

```bash
make atuin
```

Links [`atuin/config.toml`](atuin/config.toml) to `~/.config/atuin/config.toml`.
Zsh uses Atuin for Ctrl-R history search.

### Swift tools (macOS)

```bash
make swift
```

Compiles [`swift/`](swift/) into `~/.local/bin` when the Swift compiler is
available. Setup rebuilds only missing binaries or changed sources; updates do
not compile these tools.

## Maintenance

| Command | Purpose |
| --- | --- |
| `make install` | Install dependencies |
| `make setup` | Configure all components, including Swift compilation |
| `make update` / `dots-update` | Update software, plugins, and dotfiles |
| `make check` | Check syntax and configuration |

`Makefile` is the main entry point. `install.sh` installs dependencies;
`setup.sh` applies configuration. Components can be configured individually
with `make zsh`, `make nvim`, `make tmux`, `make git`, `make atuin`, or `make swift`.
