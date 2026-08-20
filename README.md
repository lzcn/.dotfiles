# Personal Dotfiles

Dotfiles for macOS and Ubuntu, managed with GNU Make.

## Install

```bash
git clone https://github.com/lzcn/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make all
```

`make all` installs, configures, and validates everything. It is safe to rerun.

On a fresh Ubuntu installation, install the bootstrap dependencies first:

```bash
sudo apt-get update
sudo apt-get install -y build-essential procps curl file git make zsh
```

## Commands

| Command         | Purpose                                      |
| --------------- | -------------------------------------------- |
| `make all`      | Install, configure, and validate everything  |
| `make install`  | Install Homebrew packages and Zinit          |
| `make setup`    | Apply configuration and symlinks             |
| `make update`   | Pull changes and reapply configuration       |
| `make validate` | Run syntax, ShellCheck, Git, and Brew checks |

Dependencies are declared in [`Brewfile`](Brewfile). Oh My Tmux is installed automatically.

## Zsh configuration

| File                        | Purpose                                       |
| --------------------------- | --------------------------------------------- |
| `zsh/.zshrc`                | Plugins, options, aliases, and keybindings    |
| `~/.zshenv`                 | Machine-local PATH, tool roots, and overrides |
| `~/.config/zsh/secrets.zsh` | API keys, tokens, and passwords               |

Setup manages `.zshrc`, creates `secrets.zsh` when missing, and updates a marked
block in the user's `~/.zshenv`. That block loads `secrets.zsh` and configures
PATH and tool roots. Content outside it is left untouched. Both local files are
private, untracked, and use mode `600`.

Example `~/.zshenv`:

```zsh
export PROXY_HTTP_PORT=7897
export PROXY_SOCKS_PORT=7897

if [[ -o interactive ]]; then
  alias work='cd ~/work'
fi
```

Example `~/.config/zsh/secrets.zsh`:

```zsh
export OPENAI_API_KEY="..."
```

Setup detects Homebrew/Linuxbrew and Conda/Mamba installation roots by location
and writes them to `~/.zshenv`; shell startup performs no detection commands.
For a custom location, pass `DOTFILES_HOMEBREW_PREFIX` or `DOTFILES_CONDA_ROOT`
when running setup. Do not set `CONDA_PREFIX`; Conda manages the active environment.

Swift tools are skipped when the compiler is unavailable. Secrets, caches,
generated binaries, and Neovim local state are not committed.
