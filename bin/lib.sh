#!/usr/bin/env zsh

# Colors auto-disabled when piped or NO_COLOR set
if [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]]; then
    C_RESET=$'\e[0m'   C_BOLD=$'\e[1m'  C_DIM=$'\e[2m'
    C_RED=$'\e[31m'    C_GREEN=$'\e[32m' C_YELLOW=$'\e[33m'
    C_BLUE=$'\e[34m'   C_MAGENTA=$'\e[35m' C_CYAN=$'\e[36m'
else
    C_RESET= C_BOLD= C_DIM=
    C_RED= C_GREEN= C_YELLOW= C_BLUE= C_MAGENTA= C_CYAN=
fi

hrule()   { print -r -- "${C_CYAN}──────────────────────────────────────────────${C_RESET}" }
ok()      { print -r -- "${C_GREEN}  ✓ $*${C_RESET}" }
warn()    { print -r -- "${C_YELLOW}  ⚠ $*${C_RESET}" }
fail()    { print -r -- "${C_RED}  ✗ $*${C_RESET}" }
info()    { print -r -- "${C_CYAN}  ● $*${C_RESET}" }
die()     { fail "$*"; exit 1 }

banner() {
    print -r -- ""
    hrule
    print -r -- "${C_BOLD}${C_CYAN}   ◈  ${C_YELLOW}$1${C_RESET}${C_BOLD}${C_CYAN}  ◈${C_RESET}"
    hrule
}

section() {
    print -r -- ""
    print -r -- "${C_BOLD}${C_BLUE}▸ $1${C_RESET}"
    print -r -- "${C_DIM}──────────────────────────────${C_RESET}"
}

finish() {
    print -r -- ""
    hrule
    print -r -- "${C_BOLD}${C_GREEN}   ✓  $1 COMPLETE   ${C_DIM}(${SECONDS}s)${C_RESET}"
    hrule
    print -r -- ""
}
