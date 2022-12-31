#!/usr/bin/env bash
DOTFILES="$(pwd)"

source "$DOTFILES/utils.sh"

setup_env() {
  # add bin to PATH
  if check_string_in_file PATH=$DOTFILES/bin ~/.zshenv; then
    success "Found $DOTFILES/bin in PATH"
  else
    append_string_in_file "[[ ! -z \$TMUX ]] || export PATH=$DOTFILES/bin:\$PATH" ~/.zshenv
  fi
  # setup brew
  if check_string_in_file HOMEBREW_PREFIX ~/.zshenv && command_exists brew; then
    success "Found brew in $HOMEBREW_PREFIX/bin"
  else
    info 'Setup $HOMEBREW_PREFIX/bin/brew'
    read -e -p 'Enter the path or Skip (N): ' HOMEBREW_PREFIX
    while ! ([[ "$HOMEBREW_PREFIX" =~ ^[Nn]$ ]] || command_exists "$HOMEBREW_PREFIX/bin/brew"); do
      warning "$HOMEBREW_PREFIX/bin/brew not found"
      read -e -p 'Enter the path or Skip (N): ' HOMEBREW_PREFIX
    done
    if command_exists "$HOMEBREW_PREFIX/bin/brew"; then
      info 'Added $HOMEBREW_PREFIX to .zshenv'
      append_string_in_file "export HOMEBREW_PREFIX=$HOMEBREW_PREFIX" ~/.zshenv
    fi
    if [[ "$HOMEBREW_PREFIX" =~ ^[Nn]$ ]]; then
      info "Skip"
    fi
  fi
  # setup conda
  if check_string_in_file CONDA_PREFIX ~/.zshenv && command_exists conda; then
    success "Found conda in $CONDA_PREFIX/bin"
  else
    info 'Setup the $CONDA_PREFIX  or Skip (N)'
    read -e -p 'Enter the path or Skip (N): ' CONDA_PREFIX
    while ! ([[ "$CONDA_PREFIX" =~ ^[Nn]$ ]] || command_exists "$CONDA_PREFIX/bin/conda"); do
      warning "$CONDA_PREFIX/bin/conda not found"
      info 'Setup the $CONDA_PREFIX or Skip (N)'
      read -e -p 'Enter the path or Skip (N): ' CONDA_PREFIX
    done
    if command_exists "$CONDA_PREFIX/bin/conda"; then
      info 'Added $CONDA_PREFIX to .zshenv'
      append_string_in_file "export CONDA_PREFIX=$CONDA_PREFIX" ~/.zshenv
    fi
    if [[ "$CONDA_PREFIX" =~ ^[Nn]$ ]]; then
      info "Skip"
    fi
  fi
}

setup_alacritty() {
  title "Configuring Alacritty"
  if command_exists alacritty; then
    symlink "$HOME/.config/alacritty" "$DOTFILES/alacritty"
  else
    info 'alacritty is not installed'
  fi
}

setup_kitty() {
  title "Configuring Kitty"
  if command_exists kitty; then
    symlink "$HOME/.config/kitty" "$DOTFILES/kitty"
  else
    info 'kitty is not installed'
  fi
}

setup_atuin() {
  title "Configuring Atuin"
  if command_exists atuin; then
    symlink "$HOME/.config/atuin/config.toml" "$DOTFILES/atuin/config.toml"
  else
    info 'atuin is not installed'
  fi
}

setup_brew() {
  xargs brew install <./brew/brew.txt
  if is_osx; then
    xargs brew install <./brew/cask.txt
  fi
}

setup_espanso() {
  title "Configuring Espanso"
  if command_exists espanso; then
    if is_osx; then
      symlink "$HOME/Library/Application Support/espanso/match" "$DOTFILES/espanso/match"
    else
      symlink "$HOME/.config/espanso/match" "$DOTFILES/espanso/match"
    fi
  else
    info 'espanso is not installed'
  fi
}

setup_git() {
  title "Configuring Git"
  symlink $HOME/.gitalias.txt $DOTFILES/git/.gitalias/gitalias.txt
  symlink $HOME/.gitconfig $DOTFILES/git/.gitconfig
  symlink $HOME/.gitignore_global $DOTFILES/git/.gitignore_global
  symlink $HOME/.git-commit-template $DOTFILES/git/.git-commit-template
}

setup_pip() {
  title "Installing Python packages"
  pip install -r $DOTFILES/pip/packages.txt
}

setup_zsh() {
  title "Configuring Zsh"
  symlink $HOME/.zshrc $DOTFILES/zsh/.zshrc
  symlink $HOME/.p10k.zsh $DOTFILES/zsh/.p10k.zsh

}

setup_lvim() {
  title "Configuring LunarVim"
  symlink $HOME/.config/lvim $DOTFILES/lvim

}

setup_tmux() {
  title "Configuring Tmux"
  symlink $HOME/.tmux.conf $DOTFILES/tmux/.tmux/.tmux.conf
  symlink $HOME/.tmux.conf.local $DOTFILES/tmux/.tmux.conf.local
}

setup_flake() {
  title "Configuring flake"
  symlink $HOME/.config/flake8 $DOTFILES/flake8/flake8
}

case "$1" in
  alacritty)
    setup_alacritty
    ;;
  atuin)
    setup_atuin
    ;;
  brew)
    setup_brew
    ;;
  espanso)
    setup_espanso
    ;;
  env)
    setup_env
    ;;
  flake)
    setup_flake
    ;;
  git)
    setup_git
    ;;
  kitty)
    setup_kitty
    ;;
  pip)
    setup_pip
    ;;
  lvim)
    setup_lvim
    ;;
  tmux)
    setup_tmux
    ;;
  zsh)
    setup_zsh
    ;;
  all)
    setup_alacritty
    setup_atuin
    setup_brew
    setup_env
    setup_flake
    setup_kitty
    setup_git
    setup_lvim
    setup_tmux
    setup_zsh
    ;;
  *)
    echo "Usage: $0 [alacritty|brew|env|flake|git|pip|lvim|tmux|zsh|all]"
    exit 1
    ;;
esac
