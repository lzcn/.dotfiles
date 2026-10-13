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

# --- Options ---

setopt interactive_comments
setopt auto_cd                  # Change directory by typing its name.

# Don't highlight pasted text.
zle_highlight+=(paste:none)

# --- History ---

[[ -n ${HISTFILE:-} ]] || HISTFILE="$HOME/.zsh_history"
(( HISTSIZE < 50000 )) && HISTSIZE=50000
(( SAVEHIST < 50000 )) && SAVEHIST=50000
setopt extended_history hist_expire_dups_first hist_find_no_dups
setopt hist_ignore_dups hist_ignore_space hist_save_no_dups
setopt hist_verify share_history

# --- Completion ---

# Native completion is ready before aliases and deferred plugins.
autoload -Uz compinit
compinit -i
autoload -Uz _zinit
_comps[zinit]=_zinit
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

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
zinit ice wait'0c' lucid atload'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(expand-or-complete)'
zinit light zsh-users/zsh-autosuggestions

# Fast syntax highlighting: command colors; load after other widgets.
zinit ice wait'0c' lucid atload'_zsh_autosuggest_start; zicdreplay'
zinit light zdharma-continuum/fast-syntax-highlighting

# Git-open: open the repository in a browser with `git open`.
zinit ice wait lucid
zinit light paulirish/git-open

# Evalcache: reuse cached initialization scripts across shell sessions.
zinit light mroth/evalcache

# Multi-word history: Ctrl-X Ctrl-R; initialize Atuin from the local binary.
zinit ice wait'0b' lucid atload'
  if (( $+commands[atuin] )); then
    _evalcache atuin init zsh
    bindkey -M vicmd "^R" atuin-search-vicmd
  fi'
zinit light zdharma-continuum/history-search-multi-word

# --- Tool initialization ---

# Homebrew: reuse cached shellenv outside tmux.
if [[ -z ${TMUX:-} && -x "${HOMEBREW_PREFIX:-}/bin/brew" ]]; then
  _evalcache "$HOMEBREW_PREFIX/bin/brew" shellenv
fi

# Conda: use its standard shell integration and the configured startup environment.
if [[ -r "${CONDA_ROOT:-}/etc/profile.d/conda.sh" ]]; then
  source "$CONDA_ROOT/etc/profile.d/conda.sh"
  [[ ${CONDA_DEFAULT_ENV:-} == "${CONDA_DEFAULT_START_ENV:-base}" ]] ||
    conda activate "${CONDA_DEFAULT_START_ENV:-base}"
  [[ -z ${CONDA_PREFIX:-} ]] || path=("$CONDA_PREFIX/bin" ${path:#"$CONDA_PREFIX/bin"})
fi

# Direnv: project environment from .envrc; enable with `direnv allow`.
(( $+commands[direnv] )) && _evalcache direnv hook zsh

# Zoxide: directory navigation with `z <directory>`.
(( $+commands[zoxide] )) && _evalcache zoxide init zsh

# --- Helpers ---

# Keep these snippets: package detection and archive formats need more than aliases.
zinit ice wait lucid
zinit snippet OMZP::command-not-found
zinit ice wait lucid
zinit snippet OMZP::extract

# --- Key bindings ---

# Fzf: Ctrl-T for files, Alt-C for directories.
if [[ -r ${HOMEBREW_PREFIX:-}/opt/fzf/shell/key-bindings.zsh ]]; then
  FZF_CTRL_R_COMMAND= source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
fi

for keymap in emacs viins vicmd; do
  bindkey -M "$keymap" '^X^R' history-search-multi-word
done

bindkey -M viins '^[p' up-line-or-search   # Alt+p for searching backward in history
bindkey -M viins '^[n' down-line-or-search # Alt+n for searching forward in history
bindkey -M viins '^[f' forward-word        # Alt+f for moving forward by word
bindkey -M viins '^[b' backward-word       # Alt+b for moving backward by word

# --- Proxy ---

# No argument toggles the current shell; endpoints come from ~/.zshenv.
proxy() {
  local action=${1:-toggle} active=off
  [[ -z ${http_proxy:-}${https_proxy:-}${all_proxy:-}${HTTP_PROXY:-}${HTTPS_PROXY:-}${ALL_PROXY:-} ]] || active=on
  if [[ $action == toggle ]]; then
    [[ $active == on ]] && action=off || action=on
  fi
  case $action in
    on)
      export http_proxy="http://${PROXY_HOST:-127.0.0.1}:${PROXY_HTTP_PORT:-7890}"
      export https_proxy=$http_proxy
      export all_proxy="socks5://${PROXY_HOST:-127.0.0.1}:${PROXY_SOCKS_PORT:-${PROXY_HTTP_PORT:-7890}}"
      export HTTP_PROXY=$http_proxy HTTPS_PROXY=$https_proxy ALL_PROXY=$all_proxy
      export no_proxy="${NO_PROXY:-localhost,127.0.0.1,::1}"
      export NO_PROXY=$no_proxy
      print 'Proxy: on'
      ;;
    off)
      unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY no_proxy NO_PROXY
      print 'Proxy: off'
      ;;
    status) print "Proxy: $active" ;;
    *) print -u2 'Usage: proxy [on|off|status]'; return 2 ;;
  esac
}

# --- Aliases ---

# Rsync aliases.
alias rsync-copy='rsync -avz --progress -h'
alias rsync-move='rsync -avz --progress -h --remove-source-files'
alias rsync-update='rsync -avzu --progress -h'
alias rsync-synchronize='rsync -avzu --delete --progress -h'

# Tmux aliases; use Oh My Tmux directly.
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tls='tmux list-sessions'
alias tlw='tmux list-windows'
alias tkss='tmux kill-session -t'

# Colored directory listings without loading an alias library.
if (( $+commands[gls] )); then
  alias ls='gls --color=auto'
elif [[ $OSTYPE == darwin* ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi

# Conda aliases
alias sra='conda activate'
alias srd='conda deactivate'

# Lazygit alias
alias lg='lazygit'

# Count number of files in current directory
alias cntfile='ls -1 | wc -l'

# Use Neovim for vim.
(( $+commands[nvim] )) && alias vim='nvim'
