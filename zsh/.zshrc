# --- Powerlevel10k instant prompt ---

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Environment ---

export LANG="${LANG:-en_US.UTF-8}"
[[ ${LC_CTYPE:-} != UTF-8 ]] || export LC_CTYPE="${LANG:-en_US.UTF-8}"
[[ -d "$HOME/.opencode/bin" ]] && path=("$HOME/.opencode/bin" $path)

# --- Zinit ---

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -r "$ZINIT_HOME/zinit.zsh" ]]; then
  print -u2 -- "zinit is not installed; run ~/.dotfiles/install.sh"
  return
fi

source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# --- Options ---

setopt interactive_comments
setopt auto_cd                  # Change directory by typing its name.
setopt auto_pushd               # Keep previous directories on the stack.
setopt pushd_ignore_dups        # Avoid duplicate stack entries.

# Don't highlight pasted text.
zle_highlight+=(paste:none)

# --- History ---

zinit snippet OMZL::history.zsh
(( SAVEHIST < 50000 )) && SAVEHIST=50000
setopt hist_find_no_dups hist_save_no_dups

# --- Theme ---

# Powerlevel10k: shell prompt.
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- Plugins ---

# Autopair: matching quotes and brackets.
zinit ice wait'0a' lucid
zinit light hlissner/zsh-autopair

# Autosuggestions: use the plugin's defaults; Tab clears history suggestions.
typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1
zinit ice wait'0c' lucid atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(fzf-tab-complete)'
zinit light zsh-users/zsh-autosuggestions

# Fast syntax highlighting: command colors; load after other widgets.
zinit ice wait'0c' lucid atload'_zsh_autosuggest_start'
zinit light zdharma-continuum/fast-syntax-highlighting

# Git-open: open the repository in a browser with `git open`.
zinit ice wait lucid
zinit light paulirish/git-open

# Evalcache: reuse cached initialization scripts across shell sessions.
zinit light mroth/evalcache

# Homebrew: reuse cached shellenv outside tmux.
if [[ -z ${TMUX:-} && -x "${HOMEBREW_PREFIX:-}/bin/brew" ]]; then
  _evalcache "$HOMEBREW_PREFIX/bin/brew" shellenv
fi

# Conda: cache the native hook; activate the configured environment or base.
if [[ -x "${CONDA_ROOT:-}/bin/conda" ]]; then
  _evalcache CONDA_AUTO_ACTIVATE_BASE=false "$CONDA_ROOT/bin/conda" shell.zsh hook
  [[ ${CONDA_DEFAULT_ENV:-} == "${CONDA_DEFAULT_START_ENV:-base}" ]] ||
    conda activate "${CONDA_DEFAULT_START_ENV:-base}"
  if [[ -n ${CONDA_PREFIX:-} && -d "$CONDA_PREFIX/bin" ]]; then
    path=("$CONDA_PREFIX/bin" ${path:#"$CONDA_PREFIX/bin"})
  fi
fi

# Direnv: project environment from .envrc; enable with `direnv allow`.
(( $+commands[direnv] )) && _evalcache direnv hook zsh

# Zoxide: directory navigation with `z <directory>`.
(( $+commands[zoxide] )) && _evalcache zoxide init zsh

# Prezto utilities; dependencies load automatically.
zstyle ':prezto:module:utility' correct no
zstyle ':prezto:module:utility:ls' color yes
zinit ice wait'0a' lucid
zinit snippet PZT::modules/utility

# Completion: Prezto defaults with fzf-tab's own Tab bindings.
zinit ice atinit'zicompinit' atload'zicdreplay'
zinit snippet PZT::modules/completion
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:*:*:*:*' menu no
zinit light Aloxaf/fzf-tab

# OMZ: package suggestions and archive extraction.
zinit ice wait lucid
zinit snippet OMZP::command-not-found
zinit ice wait lucid
zinit snippet OMZP::extract

# Multi-word history: Ctrl-X Ctrl-R.
zinit ice wait'0b' lucid
zinit light zdharma-continuum/history-search-multi-word

# Atuin: use its official integration and default search bindings.
zinit ice wait'0b' lucid has'atuin' atload'bindkey -M vicmd "^R" atuin-search-vicmd'
zinit snippet https://raw.githubusercontent.com/atuinsh/atuin/main/atuin.plugin.zsh

# Fzf: Ctrl-T for files, Alt-C for directories.
if [[ -r ${HOMEBREW_PREFIX:-}/opt/fzf/shell/key-bindings.zsh ]]; then
  FZF_CTRL_R_COMMAND= source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
fi

# --- Key bindings ---

for keymap in emacs viins vicmd; do
  bindkey -M "$keymap" '^X^R' history-search-multi-word
done

bindkey -M viins '^[p' up-line-or-search   # Alt+p for searching backward in history
bindkey -M viins '^[n' down-line-or-search # Alt+n for searching forward in history
bindkey -M viins '^[f' forward-word        # Alt+f for moving forward by word
bindkey -M viins '^[b' backward-word       # Alt+b for moving backward by word

# Quick directory stack navigation (d shows stack, 1-9 switches)
alias d='dirs -v'
for num in {1..9}; do
  alias "$num"="cd -$num"
done

# --- Aliases ---

# Proxy: `proxy on|off|status`; endpoints come from ~/.zshenv.
proxy() {
  case ${1:-help} in
    on)
      export http_proxy="http://${PROXY_HOST:-127.0.0.1}:${PROXY_HTTP_PORT:-7890}"
      export https_proxy=$http_proxy
      export all_proxy="socks5://${PROXY_HOST:-127.0.0.1}:${PROXY_SOCKS_PORT:-${PROXY_HTTP_PORT:-7890}}"
      export HTTP_PROXY=$http_proxy HTTPS_PROXY=$https_proxy ALL_PROXY=$all_proxy
      export no_proxy="${NO_PROXY:-localhost,127.0.0.1,::1}"
      export NO_PROXY=$no_proxy
      ;;
    off) unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY no_proxy NO_PROXY ;;
    status) [[ -n ${http_proxy:-}${https_proxy:-}${all_proxy:-} ]] && print 'Proxy: on' || print 'Proxy: off' ;;
    *) print 'Usage: proxy on|off|status' ;;
  esac
}

# Rsync shortcuts use OMZ's existing definitions.
zinit ice wait lucid
zinit snippet OMZP::rsync

# Tmux shortcuts; retain normal new-session behavior and the existing config.
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_FIXTERM=false
zinit ice wait lucid has'tmux' atload'zicdreplay'
zinit snippet OMZP::tmux
alias tls='tmux list-sessions'
alias tlw='tmux list-windows'

# Conda aliases
alias sra='conda activate'
alias srd='conda deactivate'

# Lazygit alias
alias lg='lazygit'

# Count number of files in current directory
alias cntfile='ls -1 | wc -l'

# Use Neovim for vim.
(( $+commands[nvim] )) && alias vim='nvim'
