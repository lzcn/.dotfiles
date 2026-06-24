#!/usr/bin/env bash
DOTFILES="$(pwd)"

source "$DOTFILES/utils.sh"

setup_env() {
  # add bin to PATH
  if check_string_in_file "PATH=$DOTFILES/bin" ~/.zshenv; then
    success "Found $DOTFILES/bin in PATH"
  else
    append_string_in_file "[[ -n \$TMUX ]] || export PATH=$DOTFILES/bin:\$PATH" ~/.zshenv
  fi
  # setup homebrew prefix
  if check_string_in_file HOMEBREW_PREFIX ~/.zshenv && command_exists brew; then
    success "Found brew in $HOMEBREW_PREFIX/bin"
  else
    info "Enter the Homebrew prefix path (where brew is installed)"
    read -r -e -p 'Enter the path or Skip (N): ' HOMEBREW_PREFIX
    while ! ([[ "$HOMEBREW_PREFIX" =~ ^[Nn]$ ]] || command_exists "$HOMEBREW_PREFIX/bin/brew"); do
      warning "$HOMEBREW_PREFIX/bin/brew not found"
      read -r -e -p 'Enter the path or Skip (N): ' HOMEBREW_PREFIX
    done
    if command_exists "$HOMEBREW_PREFIX/bin/brew"; then
      info "Added $HOMEBREW_PREFIX to .zshenv"
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
    info "Enter the Conda prefix path (where conda is installed)"
    read -r -e -p 'Enter the path or Skip (N): ' CONDA_PREFIX
    while ! ([[ "$CONDA_PREFIX" =~ ^[Nn]$ ]] || command_exists "$CONDA_PREFIX/bin/conda"); do
      warning "$CONDA_PREFIX/bin/conda not found"
      info "Enter the Conda prefix path (where conda is installed)"
      read -r -e -p 'Enter the path or Skip (N): ' CONDA_PREFIX
    done
    if command_exists "$CONDA_PREFIX/bin/conda"; then
      info "Added $CONDA_PREFIX to .zshenv"
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
    info "alacritty is not installed"
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

setup_git() {
  title "Configuring Git"
  if [[ ! -d ~/.gitalias ]]; then
    title "Installing Git Alias"
    git clone https://github.com/GitAlias/gitalias.git ~/.gitalias
  else
    success "Git Alias already installed."
  fi
  symlink ~/.gitconfig "$DOTFILES/git/.gitconfig"
}

setup_swift() {
  title "Configuring Swift"
  if is_osx && command_exists swift; then
    for swift_file in "$DOTFILES/swift"/*.swift; do
      filename=$(basename "$swift_file" .swift)
      swiftc "$swift_file" -o "$DOTFILES/bin/$filename"
      success "Compiled $filename"
    done
  else
    info "Swift setup requires macOS and Swift compiler"
  fi
}

setup_zsh() {
  title "Configuring Zsh"
  symlink "$HOME/.zshrc" "$DOTFILES/zsh/.zshrc"
  symlink "$HOME/.p10k.zsh" "$DOTFILES/zsh/.p10k.zsh"
}

setup_nvim() {
  title "Configuring Neovim"
  symlink "$HOME/.config/nvim" "$DOTFILES/nvim"
}

case "$1" in
  alacritty)
    setup_alacritty
    ;;
  atuin)
    setup_atuin
    ;;
  env)
    setup_env
    ;;
  git)
    setup_git
    ;;
  swift)
    setup_swift
    ;;
  nvim)
    setup_nvim
    ;;
  zsh)
    setup_zsh
    ;;
  all)
    setup_alacritty
    setup_atuin
    setup_env
    setup_git
    setup_swift
    setup_nvim
    setup_zsh
    ;;
  *)
    echo "Usage: $0 [alacritty|atuin|env|git|swift|nvim|zsh|all]"
    exit 1
    ;;
esac
