#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=utils.sh
source "$DOTFILES/utils.sh"

ASSUME_YES=${ASSUME_YES:-0}

ensure_private_file() {
  local path=$1
  if [[ -e $path ]]; then
    chmod 600 "$path"
    info "Found $path"
  else
    install -m 600 /dev/null "$path"
    ok "Created $path"
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
  ok "Updated $zshenv"
}

setup_atuin() {
  section "Configuring Atuin"
  if command_exists atuin; then
    symlink "$HOME/.config/atuin/config.toml" "$DOTFILES/atuin/config.toml"
  else
    info 'atuin is not installed'
  fi
}

setup_git() {
  section "Configuring Git"
  symlink ~/.gitconfig "$DOTFILES/git/.gitconfig"
  command_exists git-lfs && git lfs install --skip-repo
}

setup_tmux() {
  section "Configuring tmux"
  if [[ ! -d $HOME/.tmux/.git ]]; then
    if [[ -e $HOME/.tmux ]]; then
      question "'$HOME/.tmux' exists but is not Oh My Tmux; back it up?"
      [[ $REPLY =~ ^[Yy]$ ]] || { warn "Skipped tmux"; return; }
      backup_path "$HOME/.tmux"
    fi
    git clone --depth 1 https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
    ok "Installed Oh My Tmux"
  else
    info "Found Oh My Tmux"
  fi
  symlink "$HOME/.tmux.conf" "$HOME/.tmux/.tmux.conf"
  symlink "$HOME/.tmux.conf.local" "$DOTFILES/tmux/.tmux.conf.local"
}

setup_swift() {
  section "Configuring Swift"
  if is_osx && command_exists swift; then
    mkdir -p "$HOME/.local/bin"
    for swift_file in "$DOTFILES/swift"/*.swift; do
      filename=$(basename "$swift_file" .swift)
      swiftc "$swift_file" -o "$HOME/.local/bin/$filename"
      ok "Installed $filename -> $HOME/.local/bin/$filename"
    done
  else
    info "Swift setup requires macOS and Swift compiler"
  fi
}

setup_zsh() {
  section "Configuring Zsh"
  mkdir -p "$HOME/.config/zsh"
  ensure_private_file "$HOME/.config/zsh/secrets.zsh"
  setup_zshenv
  symlink "$HOME/.zshrc" "$DOTFILES/zsh/.zshrc"
  symlink "$HOME/.p10k.zsh" "$DOTFILES/zsh/.p10k.zsh"
}

setup_nvim() {
  section "Configuring Neovim"
  symlink "$HOME/.config/nvim" "$DOTFILES/nvim"
}

usage() {
  echo "Usage: $0 [--yes] {atuin|git|tmux|swift|nvim|zsh|all}"
  exit 1
}

banner "DOTFILES SETUP"

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

finish "SETUP"
