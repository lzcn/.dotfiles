# --- Powerlevel10k instant prompt ---

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Environment ---

export LANG="${LANG:-en_US.UTF-8}"
# Preserve Kitty truecolor over SSH before plugins load.
if [[ $TERM == xterm-kitty && -z ${COLORTERM:-} ]]; then
  export COLORTERM=truecolor
fi
[[ ${LC_CTYPE:-} != UTF-8 ]] || export LC_CTYPE="${LANG:-en_US.UTF-8}"
[[ -d "$HOME/.opencode/bin" ]] && path=("$HOME/.opencode/bin" $path)

# --- Zinit ---

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -r "$ZINIT_HOME/zinit.zsh" ]]; then
  print -u2 -- "zinit is not installed; run ~/.dotfiles/install.sh zinit"
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

[[ -z "$HISTFILE" ]] && HISTFILE="$HOME/.zsh_history"
(( HISTSIZE < 50000 )) && HISTSIZE=50000
(( SAVEHIST < 50000 )) && SAVEHIST=50000

setopt extended_history         # Record timestamps.
setopt hist_expire_dups_first   # Expire duplicates first.
setopt hist_find_no_dups        # Hide duplicates in searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_space        # Ignore commands starting with a space.
setopt hist_save_no_dups        # Save unique history entries.
setopt hist_verify              # Preview history expansions.
setopt share_history            # Share history across sessions.

# --- Theme ---

# Powerlevel10k: shell prompt.
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- Plugins ---

# Autopair: matching quotes and brackets.
zinit ice wait'0a' lucid
zinit light hlissner/zsh-autopair

# Autosuggestions: history suggestions; load after completion.
typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Keep default exclusions and prevent Tab from accepting ghost text.
typeset -ga ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(
  orig-\*
  beep
  run-help
  set-local-history
  which-command
  yank
  yank-pop
  zle-\*
  tab-complete
)

tab-complete() {
  local original_widget
  POSTDISPLAY=
  original_widget=${${(M)${(k)widgets}:#autosuggest-orig-*-expand-or-complete}[-1]}
  zle "${original_widget:-expand-or-complete}"
}
zle -N tab-complete
bindkey -M emacs '^I' tab-complete
bindkey -M viins '^I' tab-complete

zinit ice wait'0c' lucid
zinit light zsh-users/zsh-autosuggestions

# Fast syntax highlighting: command colors; load after other widgets.
zinit ice wait'0c' lucid atload'_zsh_autosuggest_start'
zinit light zdharma-continuum/fast-syntax-highlighting

# Git-open: open the repository in a browser with `git open`.
zinit ice wait lucid
zinit light paulirish/git-open

# Evalcache: cached tool initialization.
zinit light mroth/evalcache

# --- Homebrew ---

# tmux sessions normally inherit this from their parent shell.
if [[ -z ${TMUX:-} && -n ${HOMEBREW_PREFIX:-} &&
      -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
  _evalcache "$HOMEBREW_PREFIX/bin/brew" shellenv
fi

# --- Conda ---

# Load Conda without automatically activating base.
if [[ -n ${CONDA_ROOT:-} && -r "$CONDA_ROOT/etc/profile.d/conda.sh" ]]; then
  source "$CONDA_ROOT/etc/profile.d/conda.sh"
elif [[ -n ${CONDA_ROOT:-} && -x "$CONDA_ROOT/bin/conda" ]]; then
  _evalcache CONDA_AUTO_ACTIVATE_BASE=false "$CONDA_ROOT/bin/conda" shell.zsh hook
fi

if (( $+functions[conda] )) && [[ -n ${CONDA_DEFAULT_START_ENV:-} &&
      ${CONDA_DEFAULT_ENV:-} != "$CONDA_DEFAULT_START_ENV" ]]; then
  conda activate "$CONDA_DEFAULT_START_ENV"
fi

# Keep the active Conda environment first in PATH.
if [[ -n ${CONDA_PREFIX:-} && ${CONDA_SHLVL:-0} -gt 0 &&
      -d "$CONDA_PREFIX/bin" ]]; then
  path=("$CONDA_PREFIX/bin" ${path:#"$CONDA_PREFIX/bin"})
fi

# Direnv: project environment from .envrc; enable with `direnv allow`.
(( $+commands[direnv] )) && _evalcache direnv hook zsh

# Zoxide: directory navigation with `z <directory>`.
(( $+commands[zoxide] )) && _evalcache zoxide init zsh

# Prezto helper: shared shell functions.
zinit ice wait'0a' lucid
zinit snippet PZT::modules/helper

# Prezto utility: correction, globbing, and shell helpers.
zinit ice wait'0a' lucid
zinit snippet PZT::modules/utility

# Prezto completion: completion menus and fuzzy matching.
zinit ice wait'0b' lucid
zinit snippet PZT::modules/completion

# Command-not-found: package suggestions for missing commands.
zinit ice wait lucid
zinit snippet OMZP::command-not-found

# Extract: archive extraction with `extract <file>`.
zinit ice wait lucid
zinit snippet OMZP::extract

# Multi-word history: Ctrl-R; load before autosuggestions.
# Atuin: Ctrl-X Ctrl-R; initialize in the same deferred block.
zinit ice wait'0b' lucid atload'
  bindkey -M emacs "^R" history-search-multi-word
  bindkey -M viins "^R" history-search-multi-word
  bindkey -M vicmd "^R" history-search-multi-word
  if (( $+commands[atuin] )); then
    _evalcache atuin init zsh --disable-ctrl-r
  fi
  if (( $+widgets[atuin-search] )); then
    bindkey -M emacs "^X^R" atuin-search
    bindkey -M viins "^X^R" atuin-search-viins
    bindkey -M vicmd "^X^R" atuin-search-vicmd
    bindkey -M emacs "^[[A" atuin-up-search
    bindkey -M viins "^[[A" atuin-up-search-viins
    bindkey -M vicmd "^[[A" atuin-up-search-vicmd
    bindkey -M vicmd "k" atuin-up-search-vicmd
  fi'
zinit light zdharma-continuum/history-search-multi-word

# Fzf: Ctrl-T for files, Alt-C for directories.
if [[ -r ${HOMEBREW_PREFIX:-}/opt/fzf/shell/key-bindings.zsh ]]; then
  FZF_CTRL_R_COMMAND= source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
fi

# --- Key bindings ---

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

# Proxy: toggle the current shell's proxy; endpoints are set in ~/.zshenv.
# Usage: proxy [on|off|status]; no argument toggles between on and off.
proxy() {
  local is_set=0
  [[ -n ${http_proxy:-}${https_proxy:-}${all_proxy:-}${HTTP_PROXY:-}${HTTPS_PROXY:-}${ALL_PROXY:-} ]] && is_set=1

  local action=${1:-toggle}
  if [[ $action == toggle ]]; then
    (( is_set )) && action=off || action=on
  fi

  case "$action" in
    on)
      local host=${PROXY_HOST:-127.0.0.1}
      export http_proxy="http://$host:${PROXY_HTTP_PORT:-7890}"
      export https_proxy=$http_proxy
      export all_proxy="socks5://$host:${PROXY_SOCKS_PORT:-${PROXY_HTTP_PORT:-7890}}"
      export HTTP_PROXY=$http_proxy HTTPS_PROXY=$https_proxy ALL_PROXY=$all_proxy
      print 'Proxy: on'
      ;;
    off) unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY; print 'Proxy: off' ;;
    status) (( is_set )) && print 'Proxy: on' || print 'Proxy: off' ;;
    *) print -u2 'Usage: proxy [on|off|status]'; return 2 ;;
  esac
}

# Rsync aliases
alias rsync-copy='rsync -avz --progress -h'
alias rsync-move='rsync -avz --progress -h --remove-source-files'
alias rsync-update='rsync -avzu --progress -h'
alias rsync-synchronize='rsync -avzu --delete --progress -h'

# Tmux aliases
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tls='tmux list-sessions'
alias tlw='tmux list-windows'
alias tkss='tmux kill-session -t'

# Colorls aliases
if (( $+commands[colorls] )); then
  alias cls='colorls'
  alias cll='colorls -l'
  alias cla='colorls -lAh'
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

# Enable colored ls output.
if (( $+commands[gls] )); then
  alias ls='gls --color=auto'
elif [[ $OSTYPE == darwin* ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
