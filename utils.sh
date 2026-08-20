#!/usr/bin/env bash
set -euo pipefail

# Colors are disabled automatically when output is piped or NO_COLOR is set.
if [[ -t 1 && -z ${NO_COLOR:-} ]]; then
  COLOR_RESET=$'\e[0m'
  COLOR_BOLD=$'\e[1m'
  COLOR_DIM=$'\e[2m'
  COLOR_RED=$'\e[31m'
  COLOR_GREEN=$'\e[32m'
  COLOR_YELLOW=$'\e[33m'
  COLOR_BLUE=$'\e[34m'
  COLOR_CYAN=$'\e[36m'
else
  COLOR_RESET=''
  COLOR_BOLD=''
  COLOR_DIM=''
  COLOR_RED=''
  COLOR_GREEN=''
  COLOR_YELLOW=''
  COLOR_BLUE=''
  COLOR_CYAN=''
fi

hrule() { printf '%b\n' "${COLOR_CYAN}──────────────────────────────────────────────${COLOR_RESET}"; }
ok() { printf '%b\n' "${COLOR_GREEN}  ✓ $*${COLOR_RESET}"; }
warn() { printf '%b\n' "${COLOR_YELLOW}  ⚠ $*${COLOR_RESET}"; }
fail() { printf '%b\n' "${COLOR_RED}  ✗ $*${COLOR_RESET}"; }
info() { printf '%b\n' "${COLOR_CYAN}  ● $*${COLOR_RESET}"; }
die() { fail "$*"; exit 1; }

banner() {
  printf '\n'
  hrule
  printf '%b\n' "${COLOR_BOLD}${COLOR_CYAN}   ◈  ${COLOR_YELLOW}$1${COLOR_RESET}${COLOR_BOLD}${COLOR_CYAN}  ◈${COLOR_RESET}"
  hrule
}

section() {
  printf '\n'
  printf '%b\n' "${COLOR_BOLD}${COLOR_BLUE}▸ $1${COLOR_RESET}"
  printf '%b\n' "${COLOR_DIM}──────────────────────────────${COLOR_RESET}"
}

finish() {
  printf '\n'
  hrule
  printf '%b\n' "${COLOR_BOLD}${COLOR_GREEN}   ✓  $1 COMPLETE   ${COLOR_DIM}(${SECONDS}s)${COLOR_RESET}"
  hrule
  printf '\n'
}

question() {
  if [[ ${ASSUME_YES:-0} == 1 ]]; then
    REPLY='y'
    info "$1 (automatic: yes)"
    return
  fi
  printf '%b' "${COLOR_YELLOW}  ? $1 (y/n): ${COLOR_RESET}"
  REPLY=''
  read -n 1 -r REPLY || true
  printf '\n'
}

backup_path() {
  local path=$1
  local backup_file="$path.old"

  [[ -e $path || -L $path ]] || return 0
  [[ ! -e $backup_file && ! -L $backup_file ]] || backup_file="$path.old.$(date +%Y%m%d%H%M%S)"
  mv "$path" "$backup_file"
  info "Backed up $path -> $backup_file"
}

symlink() {
  local target_file=$1
  local source_file=$2

  mkdir -p "$(dirname "$target_file")"
  if [[ -e $target_file || -L $target_file ]]; then
    if [[ -L $target_file && $(readlink "$target_file") == "$source_file" ]]; then
      info "Found $target_file -> $source_file"
    else
      question "'$target_file' already exists, do you want to overwrite it?"
      if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        backup_path "$target_file"
        ln -s "$source_file" "$target_file"
        ok "Created $target_file -> $source_file"
      else
        warn "Kept existing $target_file"
      fi
    fi
  else
    ln -s "$source_file" "$target_file"
    ok "Created $target_file -> $source_file"
  fi
}

is_osx() {
  [[ $(uname) == Darwin ]]
}

command_exists() {
  local cmd="$1"
  command -v "$cmd" &>/dev/null
}
