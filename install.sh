#!/usr/bin/env bash
set -euo pipefail

# This file can run on its own to bootstrap a machine, before cloning the repo.
info() { printf '  · %s\n' "$*"; }
die() { printf '  ✗ %s\n' "$*" >&2; exit 1; }
command_exists() { command -v "$1" >/dev/null 2>&1; }

activate_homebrew() {
  local brew_bin
  for brew_bin in "${HOMEBREW_PREFIX:-}/bin/brew" /opt/homebrew/bin/brew \
    /home/linuxbrew/.linuxbrew/bin/brew "$HOME/.linuxbrew/bin/brew" /usr/local/bin/brew; do
    if [[ -x $brew_bin ]]; then
      eval "$("$brew_bin" shellenv)"
      return
    fi
  done
  if command_exists brew; then eval "$(brew shellenv)"; else return 1; fi
}

install_homebrew() {
  if activate_homebrew; then
    info "Homebrew ready"
  else
    local installer
    installer=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
    bash -c "$installer"
    activate_homebrew || die "Homebrew could not be activated"
  fi
}

bootstrap() {
  local destination=${DOTFILES_DIR:-$HOME/.dotfiles}
  printf '\nDotfiles · bootstrap\n\n'
  case $(uname -s) in
    Linux)
      command_exists apt-get || die "Bootstrap supports Ubuntu and macOS"
      local elevate=()
      if [[ $EUID != 0 ]]; then elevate=(sudo); fi
      info "Preparing Ubuntu prerequisites"
      "${elevate[@]}" apt-get update
      "${elevate[@]}" apt-get install -y build-essential procps curl file git make zsh
      ;;
    Darwin) info "Preparing macOS (Homebrew may request Command Line Tools or sudo)" ;;
    *) die "Bootstrap supports Ubuntu and macOS" ;;
  esac
  install_homebrew
  if [[ ! -e $destination ]]; then
    git clone https://github.com/lzcn/.dotfiles.git "$destination"
  elif [[ ! -d $destination/.git || ! -f $destination/Makefile ]]; then
    die "$destination exists but is not a dotfiles checkout"
  fi
  make -C "$destination" all
  info "Open a new Zsh session to use the configuration"
}

if [[ ${1:-bootstrap} == bootstrap ]]; then
  bootstrap
  exit
fi

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=bin/lib.sh
source "$DOTFILES/bin/lib.sh"
trap 'fail "Installation stopped at line $LINENO; fix the error above and rerun make all"' ERR

install_packages() {
  section "Homebrew packages"
  activate_homebrew || die "Homebrew is required before packages"
  brew bundle --no-upgrade --file "$DOTFILES/Brewfile"
  ok "Packages ready"
}

install_zinit() {
  section "Zinit"
  local zinit_home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  if [[ ! -f $zinit_home/zinit.zsh ]]; then
    mkdir -p "$(dirname "$zinit_home")"
    git clone --depth 1 https://github.com/zdharma-continuum/zinit.git "$zinit_home"
  fi
  ok "Zinit ready"
}

banner "Dotfiles · install"
for target in "$@"; do
  case "$target" in
    homebrew) install_homebrew ;;
    packages) install_packages ;;
    zinit) install_zinit ;;
    all) install_homebrew; install_packages; install_zinit ;;
    *) die "Usage: $0 [bootstrap|homebrew|packages|zinit|all]" ;;
  esac
done
finish "Installation complete"
