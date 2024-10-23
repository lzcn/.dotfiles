#!/usr/bin/env bash
DOTFILES="$(pwd)"

source $DOTFILES/utils.sh

install_cargo() {
  title "Installing Cargo"
  curl https://sh.rustup.rs -sSf | sh
}

install_homebrew() {
  title "Installing Homebrew"
  if command_exists brew; then
    success "Homebrew already installed"
  else
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

install_zinit() {
  title "Installing Zinit"
  if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
  else
    success "Zinit already installed."
  fi
}

install_fnm() {
  title "Installing Fast Node Manager"
  if command_exists fnm; then
    success "FNM already installed"
  else
    curl -fsSL https://fnm.vercel.app/install | bash
  fi
}


case "$1" in
  fnm)
    install_fnm
    ;;
  homebrew)
    install_homebrew
    ;;
  zinit)
    install_zinit
    ;;
  all)
    install_homebrew
    install_zinit
    ;;
  *)
    echo "Usage: $0 {cargo|homebrew|zinit|all}"
    exit 1
    ;;
esac
