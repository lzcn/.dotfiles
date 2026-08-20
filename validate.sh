#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=utils.sh
source "$DOTFILES/utils.sh"

failures=0

check() {
  local name="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    ok "$name"
  else
    fail "$name"
    "$@" || true
    failures=$((failures + 1))
  fi
}

banner "DOTFILES VALIDATE"

# Shell syntax checks
section "Shell syntax"
for f in "$DOTFILES"/{install,setup,utils,validate}.sh "$DOTFILES"/bin/*; do
  case "$f" in
    *.swift) continue ;;
  esac
  # Skip compiled binaries / non-shell files
  [[ -f "$f" ]] || continue
  LC_ALL=C grep -Iq '^#!' "$f" || continue
  IFS= read -r local_shebang <"$f"
  if [[ "$local_shebang" == *zsh* ]]; then
    check "$(basename "$f")" zsh -n "$f"
  else
    check "$(basename "$f")" bash -n "$f"
  fi
done

check "zshrc" zsh -n "$DOTFILES/zsh/.zshrc"
check "p10k" zsh -n "$DOTFILES/zsh/.p10k.zsh"

# ShellCheck (bash scripts)
if command -v shellcheck >/dev/null 2>&1; then
  section "ShellCheck"
  check "shellcheck(install.sh)" shellcheck -x -P "$DOTFILES" "$DOTFILES/install.sh"
  check "shellcheck(setup.sh)" shellcheck -x -P "$DOTFILES" "$DOTFILES/setup.sh"
  check "shellcheck(utils.sh)" shellcheck -x -P "$DOTFILES" "$DOTFILES/utils.sh"
  check "shellcheck(validate.sh)" shellcheck -x -P "$DOTFILES" "$DOTFILES/validate.sh"
else
  warn "shellcheck not installed; skipping (brew install shellcheck)"
fi

# Git config sanity
section "Git config"
check "gitconfig parse" git config --file "$DOTFILES/git/.gitconfig" --list

# Brewfile syntax (does not require every package to be installed yet)
if command -v brew >/dev/null 2>&1; then
  section "Homebrew bundle"
  check "Brewfile parse" brew bundle list --file "$DOTFILES/Brewfile"
fi

# Markdown lint if available
if command -v markdownlint >/dev/null 2>&1; then
  section "Markdown"
  check "markdownlint" markdownlint "$DOTFILES/README.md"
fi

echo
if [[ $failures -gt 0 ]]; then
  fail "$failures check(s) failed."
  exit 1
fi
ok "All checks passed."
finish "VALIDATE"
