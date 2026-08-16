#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DOTFILES/utils.sh"

ZSENV="$HOME/.zshenv"

ensure_zshenv() {
  [[ -f "$ZSENV" ]] || touch "$ZSENV"
}

append_if_missing() {
  local pattern="$1"
  if check_string_in_file "$pattern" "$ZSENV"; then
    success "Found $pattern in $ZSENV"
  else
    cat >>"$ZSENV" <&0
    success "Appended $pattern to $ZSENV"
  fi
}

setup_env() {
  title "Configuring environment"
  ensure_zshenv

  # add bin to PATH (unless inside tmux).
  # zsh-only: use the `path` array; the one-liner form errors under `nounset`
  # (`TMUX: parameter not set`) and is redundant with the block below.
  append_if_missing "dotfiles/bin" <<'BLOCK'

# dotfiles helper binaries.
# Do not prepend them again inside tmux; the tmux server/session inherits
# the environment from the shell that launched it.
if [[ -z ${TMUX:-} ]]; then
  path=(
    "$HOME/.dotfiles/bin"
    $path
  )
fi
BLOCK

  # homebrew prefix
  if check_string_in_file HOMEBREW_PREFIX "$ZSENV"; then
    success "Found HOMEBREW_PREFIX in $ZSENV"
  elif command_exists brew; then
    append_if_missing "HOMEBREW_PREFIX" <<EOF
export HOMEBREW_PREFIX="$(brew --prefix)"
EOF
  else
    info "Homebrew not found; HOMEBREW_PREFIX will not be set."
  fi

  # conda prefix
  if check_string_in_file CONDA_PREFIX "$ZSENV"; then
    success "Found CONDA_PREFIX in $ZSENV"
  elif command_exists conda; then
    append_if_missing "CONDA_PREFIX" <<EOF
export CONDA_PREFIX="$(conda info --base)"
EOF
  else
    info "Conda not found; CONDA_PREFIX will not be set."
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

usage() {
  echo "Usage: $0 {atuin|env|git|swift|nvim|zsh|all}"
  exit 1
}

if [[ $# -eq 0 ]]; then
  usage
fi

for target in "$@"; do
  case "$target" in
    atuin) setup_atuin ;;
    env) setup_env ;;
    git) setup_git ;;
    swift) setup_swift ;;
    nvim) setup_nvim ;;
    zsh) setup_zsh ;;
    all)
      setup_atuin
      setup_env
      setup_git
      setup_swift
      setup_nvim
      setup_zsh
      ;;
    *) usage ;;
  esac
done
