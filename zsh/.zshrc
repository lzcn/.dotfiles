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
  print -u2 -- "zinit is not installed; run ~/.dotfiles/install.sh zinit"
  return
fi

source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# --- Options ---

setopt interactive_comments

# Don't highlight pasted text.
zle_highlight+=(paste:none)

# --- History ---

[[ -z "$HISTFILE" ]] && HISTFILE="$HOME/.zsh_history"
(( HISTSIZE < 50000 )) && HISTSIZE=50000
(( SAVEHIST < 10000 )) && SAVEHIST=10000

setopt extended_history       # record timestamps in history
setopt hist_expire_dups_first # expire duplicate entries first
setopt hist_ignore_dups       # ignore consecutive duplicates
setopt hist_ignore_space      # ignore commands starting with space
setopt hist_verify            # show expanded command before executing
setopt share_history          # share history across sessions

# --- Theme ---

# Powerlevel10k: fast, customizable prompt.
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- Plugins ---

# Autopair: close matching quotes and brackets.
zinit ice wait'0a' lucid
zinit light hlissner/zsh-autopair

# Autosuggestions: suggest commands from history.
# Loads after the completion system (see the Prezto snippets below) so that
# Tab clears the suggestion instead of appending its remainder.
typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1
zinit ice wait'0c' lucid
zinit light zsh-users/zsh-autosuggestions

# Fast syntax highlighting: load after other editor widgets.
zinit ice wait'0c' lucid atload'_zsh_autosuggest_start'
zinit light zdharma-continuum/fast-syntax-highlighting

# Zsh completions: command definitions and completion initialization.
# Prezto's completion module supplies menu colors, grouping, fuzzy matching,
# and context rules; it is loaded once below.

# Git-open: open the current repository in a browser.
# Usage: git open
zinit ice wait lucid
zinit light paulirish/git-open

# Evalcache: cache tool initialization to speed up startup.
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

# Direnv: load project-local environment variables.
# Usage: edit .envrc, then run direnv allow.
(( $+commands[direnv] )) && _evalcache direnv hook zsh

# Zoxide: jump to frequently used directories.
# Usage: z <directory name>
(( $+commands[zoxide] )) && _evalcache zoxide init zsh

# FZF: Ctrl-T picks files, Alt-C picks directories.
# Disabled for now; history search (Ctrl-R, up-arrow) stays with Atuin only.
# (( $+commands[fzf] )) && source <(fzf --zsh)

# Keep the plugin set small; project-specific tools can add their own completions.

# Prezto helper: shared functions used by utility and completion.
zinit ice wait'0a' lucid
zinit snippet PZT::modules/helper

# Prezto utility: safe correction/globbing defaults and shell helpers.
zinit ice wait'0a' lucid
zinit snippet PZT::modules/utility

# Prezto completion: menu colors, grouping, fuzzy matching, and context rules.
# This is the only completion initializer; turbo keeps compinit off startup.
zinit ice wait'0b' lucid
zinit snippet PZT::modules/completion

# Shell helpers and completion styles.
# Command-not-found: suggest a package when a command is missing.
zinit ice wait lucid
zinit snippet OMZP::command-not-found

# Extract: unpack common archive formats with `extract <file>`.
zinit ice wait lucid
zinit snippet OMZP::extract

# Atuin: searchable shell history.
# Usage: Ctrl-R to search.
(( $+commands[atuin] )) && _evalcache atuin init zsh

# --- Key bindings ---

bindkey -M viins '^[p' up-line-or-search   # Alt+p for searching backward in history
bindkey -M viins '^[n' down-line-or-search # Alt+n for searching forward in history
bindkey -M viins '^[f' forward-word        # Alt+f for moving forward by word
bindkey -M viins '^[b' backward-word       # Alt+b for moving backward by word

# --- Aliases ---

# Proxy: toggle the current shell's proxy; endpoints are set in ~/.zshenv.
# Usage: proxy on | off | status
proxy() {
  case "${1:-status}" in
    on)
      local host=${PROXY_HOST:-127.0.0.1}
      export http_proxy="http://$host:${PROXY_HTTP_PORT:-7890}"
      export https_proxy=$http_proxy
      export all_proxy="socks5://$host:${PROXY_SOCKS_PORT:-${PROXY_HTTP_PORT:-7890}}"
      export HTTP_PROXY=$http_proxy HTTPS_PROXY=$https_proxy ALL_PROXY=$all_proxy
      ;;
    off) unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY ;;
    status) [[ -n ${http_proxy:-}${https_proxy:-}${all_proxy:-}${HTTP_PROXY:-}${HTTPS_PROXY:-}${ALL_PROXY:-} ]] && print 'Proxy: on' || print 'Proxy: off' ;;
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
