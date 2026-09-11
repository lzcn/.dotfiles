#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=bin/lib.sh
source "$DOTFILES/bin/lib.sh"
trap 'fail "Setup stopped at line $LINENO; fix the error above and rerun make setup"' ERR

# A fresh installation may not have loaded .zshenv yet.
for brew_prefix in "${HOMEBREW_PREFIX:-}" /opt/homebrew /home/linuxbrew/.linuxbrew "$HOME/.linuxbrew" /usr/local; do
  if [[ -n $brew_prefix && -x $brew_prefix/bin/brew ]]; then
    eval "$("$brew_prefix/bin/brew" shellenv)"
    break
  fi
done
unset brew_prefix
command_exists() { command -v "$1" >/dev/null 2>&1; }

question() {
  REPLY=y
  if [[ ${ASSUME_YES:-0} != 1 ]]; then
    read -r -p "$1 [y/N] " REPLY || REPLY=n
  fi
}

backup_path() {
  local backup="$1.old"
  while [[ -e $backup || -L $backup ]]; do backup="$backup.old"; done
  mv "$1" "$backup"
  info "Backed up $1 -> $backup"
}

symlink() {
  local target=$1 source=$2
  mkdir -p "$(dirname "$target")"
  if [[ -L $target && $(readlink "$target") == "$source" ]]; then
    return 0
  fi
  if [[ -e $target || -L $target ]]; then
    question "Back up '$target' and replace it with a symlink?"
    [[ $REPLY =~ ^[Yy]$ ]] || { info "Kept $target"; return 0; }
    backup_path "$target"
  fi
  ln -s "$source" "$target"
  info "Linked $target -> $source"
}

ASSUME_YES=${ASSUME_YES:-0}

ensure_private_file() {
  local path=$1
  if [[ -e $path ]]; then
    chmod 600 "$path"
    info "Found $path"
  else
    install -m 600 /dev/null "$path"
    info "Created $path"
  fi
}

setup_zshenv() {
  local zshenv="$HOME/.zshenv"
  local start_marker='# >>> dotfiles managed environment >>>'
  local end_marker='# <<< dotfiles managed environment <<<'
  local brew_prefix=${DOTFILES_HOMEBREW_PREFIX:-}
  local conda_root=${DOTFILES_CONDA_ROOT:-}
  local prefix tmp

  if [[ -z $brew_prefix ]]; then
    for prefix in \
      /opt/homebrew \
      /home/linuxbrew/.linuxbrew \
      "$HOME/.linuxbrew" \
      "$HOME/homebrew" \
      /usr/local; do
      if [[ -x "$prefix/bin/brew" ]]; then
        brew_prefix=$prefix
        break
      fi
    done
  fi

  if [[ -z $conda_root ]]; then
    for prefix in \
      "$HOME/miniforge3" /opt/miniforge3 \
      "$HOME/miniforge" /opt/miniforge \
      "$HOME/mambaforge" /opt/mambaforge \
      "$HOME/miniconda3" /opt/miniconda3 \
      "$HOME/miniconda" /opt/miniconda \
      "$HOME/anaconda3" /opt/anaconda3 \
      "$HOME/anaconda" /opt/anaconda \
      "$HOME/conda" /opt/conda \
      "$HOME/.local/share/mamba" "$HOME/micromamba" /opt/mamba; do
      if [[ -x "$prefix/bin/conda" || -x "$prefix/bin/mamba" || -x "$prefix/bin/micromamba" ]]; then
        conda_root=$prefix
        break
      fi
    done
  fi

  tmp=$(mktemp "$HOME/.zshenv.XXXXXX")
  if [[ -f $zshenv ]]; then
    awk -v start="$start_marker" -v end="$end_marker" '
      $0 == start { managed = 1; next }
      $0 == end { managed = 0; next }
      !managed { lines[++count] = $0 }
      END {
        while (count && lines[count] == "") count--
        for (line = 1; line <= count; line++) print lines[line]
      }
    ' "$zshenv" >"$tmp"
  fi

  {
    printf '\n%s\n' "$start_marker"
    printf '# Updated by ~/.dotfiles/setup.sh; edit outside this block.\n'
    # This expression belongs in the generated zsh file.
    # shellcheck disable=SC2016
    printf '%s\n' '[[ ! -r "$HOME/.config/zsh/secrets.zsh" ]] || source "$HOME/.config/zsh/secrets.zsh"'
    [[ -z $brew_prefix ]] || printf 'export HOMEBREW_PREFIX=%q\n' "$brew_prefix"
    [[ -z $conda_root ]] || printf 'export CONDA_ROOT=%q\n' "$conda_root"
    # These expressions belong in the generated zsh file.
    # shellcheck disable=SC2016
    printf '%s\n' \
      'typeset -U path PATH' \
      'path=(' \
      "  \"$DOTFILES/bin\"" \
      '  "$HOME/.local/bin"' \
      '  ${HOMEBREW_PREFIX:+"$HOMEBREW_PREFIX/bin"}' \
      '  ${HOMEBREW_PREFIX:+"$HOMEBREW_PREFIX/sbin"}' \
      '  ${CONDA_ROOT:+"$CONDA_ROOT/bin"}' \
      '  $path' \
      ')' \
      'export PATH'
    printf '%s\n' "$end_marker"
  } >>"$tmp"

  chmod 600 "$tmp"
  mv -f "$tmp" "$zshenv"
  info "Updated $zshenv"
}

setup_atuin() {
  section "Atuin"
  if command_exists atuin; then
    symlink "$HOME/.config/atuin/config.toml" "$DOTFILES/atuin/config.toml"
  else
    info 'atuin is not installed'
  fi
}

setup_git() {
  section "Git"
  symlink ~/.gitconfig "$DOTFILES/git/.gitconfig"
  if command_exists git-lfs; then git lfs install --skip-repo; fi
}

setup_tmux() {
  section "tmux"
  if [[ ! -d $HOME/.tmux/.git ]]; then
    if [[ -e $HOME/.tmux ]]; then
      question "'$HOME/.tmux' exists but is not Oh My Tmux; back it up?"
      [[ $REPLY =~ ^[Yy]$ ]] || { info "Skipped tmux"; return; }
      backup_path "$HOME/.tmux"
    fi
    git clone --depth 1 https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
    info "Installed Oh My Tmux"
  else
    info "Found Oh My Tmux"
  fi
  symlink "$HOME/.tmux.conf" "$HOME/.tmux/.tmux.conf"
  symlink "$HOME/.tmux.conf.local" "$DOTFILES/tmux/.tmux.conf.local"
}

setup_swift() {
  section "Swift"
  local swift_file filename output
  if [[ $(uname) == Darwin ]] && command_exists swiftc; then
    mkdir -p "$HOME/.local/bin"
    for swift_file in "$DOTFILES/swift"/*.swift; do
      filename=$(basename "$swift_file" .swift)
      output="$HOME/.local/bin/$filename"
      if [[ ! -x $output || $swift_file -nt $output ]]; then
        swiftc "$swift_file" -o "$output"
        info "Built $output"
      else
        info "Up to date: $filename"
      fi
    done
  else
    info "Swift setup requires macOS and Swift compiler"
  fi
}

setup_zsh() {
  section "Zsh"
  mkdir -p "$HOME/.config/zsh"
  ensure_private_file "$HOME/.config/zsh/secrets.zsh"
  setup_zshenv
  symlink "$HOME/.zshrc" "$DOTFILES/zsh/.zshrc"
  symlink "$HOME/.p10k.zsh" "$DOTFILES/zsh/.p10k.zsh"
}

setup_nvim() {
  section "Neovim"
  symlink "$HOME/.config/nvim" "$DOTFILES/nvim"
}

usage() {
  echo "Usage: $0 [--yes] {atuin|git|tmux|swift|nvim|zsh|all}"
  exit 1
}

banner "Dotfiles · setup"

targets=()
for arg in "$@"; do
  case "$arg" in
    --yes|-y) ASSUME_YES=1 ;;
    *) targets+=("$arg") ;;
  esac
done
set -- "${targets[@]}"

if [[ $# -eq 0 ]]; then
  usage
fi

for target in "$@"; do
  case "$target" in
    atuin) setup_atuin ;;
    git) setup_git ;;
    tmux) setup_tmux ;;
    swift) setup_swift ;;
    nvim) setup_nvim ;;
    zsh) setup_zsh ;;
    all)
      setup_atuin
      setup_git
      setup_tmux
      setup_swift
      setup_nvim
      setup_zsh
      ;;
    *) usage ;;
  esac
done

finish "Configuration complete"
