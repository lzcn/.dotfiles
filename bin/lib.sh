#!/usr/bin/env bash
# Shared output helpers; compatible with Bash and Zsh.

# Colors are also used by scripts sourcing this file.
# shellcheck disable=SC2034
C_RESET='' C_BOLD='' C_DIM='' C_RED='' C_GREEN='' C_YELLOW='' C_BLUE='' C_MAGENTA='' C_CYAN=''
if [[ -t 1 && -z ${NO_COLOR:-} && ${TERM:-} != dumb ]]; then
    C_RESET=$'\033[0m' C_BOLD=$'\033[1m' C_DIM=$'\033[2m'
    C_RED=$'\033[31m' C_GREEN=$'\033[32m' C_YELLOW=$'\033[33m'
    # shellcheck disable=SC2034
    C_BLUE=$'\033[34m' C_MAGENTA=$'\033[35m' C_CYAN=$'\033[36m'
fi

hrule() { printf '%s────────────────────────────────────────%s\n' "$C_DIM" "$C_RESET"; }
ok()    { printf '%s  ✓%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
warn()  { printf '%s  !%s %s\n' "$C_YELLOW" "$C_RESET" "$*"; }
fail()  { printf '%s  ✗%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; }
info()  { printf '%s  ·%s %s\n' "$C_DIM" "$C_RESET" "$*"; }
die()   { fail "$*"; exit 1; }
banner()  { printf '\n%s%s%s\n' "$C_BOLD" "$1" "$C_RESET"; hrule; }
section() { printf '\n%s› %s%s\n' "$C_CYAN" "$1" "$C_RESET"; }
finish()  { printf '\n'; ok "$1 · ${SECONDS}s"; }
