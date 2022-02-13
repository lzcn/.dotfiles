# Personal dotfiles.

This repository contains my personal configuration files, scripts for better terminal experience, which includes:

- Alacritty. Terminal app.
- Git. Aliases and configurations for git are included.
- Homebrew. Homebrew is a package manager for macOS and Linux.
- Tmux. Tmux is a terminal multiplexer that allows you to run multiple programs in one terminal.
- Zsh. Oh-my-zsh and Zinit are used for the zsh shell.
- Nvim. LunarVim is used.
- Scripts. Some scripts I use for my daily work.

## Installation

1.  clone the repository with its sub-modules into `.dotfiles`.

    ```bash
    git clone https://www.github.com/lzcn/.dotfiles.git
    cd .dotfiles
    git submodule update --init --recursive
    ```

2.  install dependencies

    ```bash
    ./install.sh -h
    ```

3.  setup dotfiles

    3.1 manually add the path to `~/.zshenv` or run `./setup.sh env` for `brew` and `conda`

        ```
        # for $HOMEBREW_PREFIX/brew
        export HOMEBREW_PREFIX=
        # for $CONDA_PREFIX/conda
        export CONDA_PREFIX=
        ```

    3.2 setup the configuration files for others.

        ```bash
        ./setup.sh -h
        ```
