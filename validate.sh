#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

failures=0

check() {
  local name="$1"
  shift
  echo -n "checking ${name}... "
  if "$@" >/dev/null 2>&1; then
    echo "OK"
  else
    echo "FAIL"
    failures=$((failures + 1))
  fi
}

# Shell syntax checks
for f in "$DOTFILES"/{install,setup,utils,validate}.sh "$DOTFILES"/bin/*; do
  case "$f" in
    *.swift) continue ;;
  esac
  # Skip compiled binaries / non-shell files
  [[ -f "$f" ]] || continue
  local_shebang=$(head -1 "$f")
  if [[ "$local_shebang" != \#!* ]]; then
    continue
  fi
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
  check "shellcheck(install.sh)" shellcheck -x "$DOTFILES/install.sh"
  check "shellcheck(setup.sh)" shellcheck -x "$DOTFILES/setup.sh"
  check "shellcheck(utils.sh)" shellcheck -x "$DOTFILES/utils.sh"
  check "shellcheck(validate.sh)" shellcheck -x "$DOTFILES/validate.sh"
else
  echo "shellcheck not installed; skipping (brew install shellcheck)"
fi

# Git config sanity
check "gitconfig parse" git config --file "$DOTFILES/git/.gitconfig" --list

# Markdown lint if available
if command -v markdownlint >/dev/null 2>&1; then
  check "markdownlint" markdownlint "$DOTFILES/README.md"
fi

if [[ $failures -gt 0 ]]; then
  echo
  echo "FAILED: ${failures} check(s)."
  exit 1
fi

echo
echo "All checks passed."
