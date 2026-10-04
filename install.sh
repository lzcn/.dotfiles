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
      "${elevate[@]}" apt-get install -y build-essential procps curl file git make python3 zsh
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
  make -C "$destination" install
  info "Open a new Zsh session to use the configuration"
}

usage() {
  printf '%s\n' 'Usage: install.sh [bootstrap]' \
    '  (default)  Install dependencies for this checkout' \
    '  bootstrap  Prepare a new machine, clone dotfiles, and run make install' \
    '  -h, --help Show help'
}

if [[ $# -gt 1 ]]; then
  usage >&2
  exit 2
fi
case ${1:-} in
  bootstrap) bootstrap; exit ;;
  "") ;;
  --help|-h) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=bin/lib.sh
source "$DOTFILES/bin/lib.sh"
trap 'fail "Installation stopped at line $LINENO; fix the error above and rerun make install"' ERR

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

banner "Dotfiles · dependencies"
install_homebrew
install_packages
install_zinit
finish "Dependencies ready"
