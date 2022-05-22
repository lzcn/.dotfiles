# Personal Dotfiles

This repository contains my personal configuration files, scripts etc., which includes:

- Alacritty. Terminal app.
- Git. Aliases and configurations for git are included.
- Brew. Homebrew is a package manager for macOS and Linux.
- Tmux. Tmux is a terminal multiplexer that allows you to run multiple programs in one terminal.
- Zsh. Oh-my-zsh and Zinit are used for the zsh shell.
- Nvim. LunarVim is used.
- Scripts. Some scripts I use for my daily work.

## Installation

1.  Clone the repository with its sub-modules.

    ```bash
    git clone https://www.github.com/lzcn/.dotfiles.git
    cd .dotfiles
    git submodule update --init --recursive
    ```

2.  Install dependencies

    ```bash
    ./install.sh -h
    ```

3.  Setup

    1. Since different OS use different installation for homebrew and conda, we manually add the path to `~/.zshenv` or run `./setup.sh env` for `brew` and `conda`:

    ```bash
    # for $HOMEBREW_PREFIX/brew
    export HOMEBREW_PREFIX=
    # for $CONDA_PREFIX/conda
    export CONDA_PREFIX=
    ```

    2. Setup the configuration for different software:

    ```bash
    ./setup.sh -h
    ```
