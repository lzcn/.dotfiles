#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DOTFILES/utils.sh"

activate_homebrew() {
  local brew_bin=''

  if command_exists brew; then
    brew_bin=$(command -v brew)
  elif [[ -x /opt/homebrew/bin/brew ]]; then
    brew_bin=/opt/homebrew/bin/brew
  elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    brew_bin=/home/linuxbrew/.linuxbrew/bin/brew
  elif [[ -x $HOME/.linuxbrew/bin/brew ]]; then
    brew_bin=$HOME/.linuxbrew/bin/brew
  elif [[ -x /usr/local/bin/brew ]]; then
    brew_bin=/usr/local/bin/brew
  fi

  [[ -n $brew_bin ]] || return 1
  eval "$("$brew_bin" shellenv)"
}

install_homebrew() {
  section "Installing Homebrew"
  if activate_homebrew; then
    ok "Homebrew already installed"
  else
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    activate_homebrew || die "Homebrew installed but could not be activated"
    ok "Homebrew installed"
  fi
}

install_packages() {
  section "Installing command-line tools"
  activate_homebrew || die "Homebrew is required before packages"
  brew bundle --file "$DOTFILES/Brewfile"
  ok "Homebrew packages installed"
}

install_zinit() {
  section "Installing Zinit"
  if [[ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
  else
    ok "Zinit already installed."
  fi
}

usage() {
  echo "Usage: $0 {homebrew|packages|zinit|all}"
  exit 1
}

banner "DOTFILES INSTALL"

if [[ $# -eq 0 ]]; then
  usage
fi

for target in "$@"; do
  case "$target" in
    homebrew) install_homebrew ;;
    packages) install_packages ;;
    zinit) install_zinit ;;
    all)
      install_homebrew
      install_packages
      install_zinit
      ;;
    *) usage ;;
  esac
done

finish "INSTALL"
