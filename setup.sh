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
    if [[ ! -d $HOME/.config/alacritty/themes ]]; then
      title "Installing themes"
      mkdir -p $HOME/config/alacritty/themes
      git clone https://github.com/alacritty/alacritty-theme $HOME/.config/alacritty/themes --depth 1
    else
      info "Update alacritty themes"
      # update themes
      cd $HOME/.config/alacritty/themes
      git pull
      cd $DOTFILES
    fi

  else
    info 'alacritty is not installed'
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
  # if is_osx; then
  #   xargs brew install <./brew/cask.txt
  # fi
}

setup_git() {
  title "Configuring Git"
  if [[ ! -d ~/.gitalias ]]; then
    title "Installing Git Alias"
    git clone https://github.com/GitAlias/gitalias.git ~/.gitalias
  else
    success "Git Alias already installed."
  fi
  symlink ~/.gitconfig "$DOTFILES"/git/.gitconfig
}

setup_pip() {
  title "Installing Python packages"
  pip install -r $DOTFILES/pip/packages.txt
}

setup_swift() {
  title "Configuring Swift"
  if is_osx && command_exists swift; then
    mkdir -p ~/.local/bin
    for swift_file in "$DOTFILES/swift"/*.swift; do
      filename=$(basename "$swift_file" .swift)
      swiftc "$swift_file" -o "$HOME/.local/bin/$filename"
      success "Compiled $filename"
    done
  else
    info "Swift setup requires macOS and Swift compiler"
  fi
}

setup_zsh() {
  title "Configuring Zsh"
  symlink $HOME/.zshrc $DOTFILES/zsh/.zshrc
  symlink $HOME/.p10k.zsh $DOTFILES/zsh/.p10k.zsh

}

setup_nvim() {
  title "Configuring Neovim"
  symlink $HOME/.config/nvim $DOTFILES/nvim
}

setup_tmux() {
  title "Configuring Tmux"
  if [[ ! -d ~/.tmux ]]; then
    title "Installing Oh My Tmux"
    git clone https://github.com/gpakosz/.tmux.git ~/.tmux
  else
    success "Oh My Tmux already installed."
  fi
  symlink ~/.tmux.conf ~/.tmux/.tmux.conf
  symlink ~/.tmux.conf.local "$DOTFILES"/tmux/.tmux.conf.local
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
  env)
    setup_env
    ;;
  git)
    setup_git
    ;;
  pip)
    setup_pip
    ;;
  swift)
    setup_swift
    ;;
  nvim)
    setup_nvim
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
    setup_git
    setup_pip
    setup_swift
    setup_nvim
    setup_tmux
    setup_zsh
    ;;
  *)
    echo "Usage: $0 [alacritty|atuin|brew|env|git|pip|swift|nvim|tmux|zsh|all]"
    exit 1
    ;;
esac
