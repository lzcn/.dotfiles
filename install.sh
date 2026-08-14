#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DOTFILES/utils.sh"

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
  if [[ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
  else
    success "Zinit already installed."
  fi
}

usage() {
  echo "Usage: $0 {homebrew|zinit|all}"
  exit 1
}

if [[ $# -eq 0 ]]; then
  usage
fi

for target in "$@"; do
  case "$target" in
    homebrew) install_homebrew ;;
    zinit) install_zinit ;;
    all)
      install_homebrew
      install_zinit
      ;;
    *) usage ;;
  esac
done
