# --- Powerlevel10k instant prompt ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Environment ---
# Machine-local environment belongs in ~/.zshenv. Secrets stay in one private
# file loaded by ~/.zshenv.
export LANG="${LANG:-en_US.UTF-8}"
[[ ${LC_CTYPE:-} != UTF-8 ]] || export LC_CTYPE="${LANG:-en_US.UTF-8}"
[[ ! -d "$HOME/.opencode/bin" ]] || path=("$HOME/.opencode/bin" $path)

# --- Zinit ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -r "$ZINIT_HOME/zinit.zsh" ]]; then
  print -u2 -- "zinit is not installed; run ~/.dotfiles/install.sh zinit"
  return
fi
source "$ZINIT_HOME/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# --- Opts ---
setopt interactive_comments

# Don't highlight pasted text (bracketed paste)
zle_highlight+=(paste:none)

# --- History configuration ---
# Follows Oh My Zsh lib/history.zsh
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

setopt extended_history       # record timestamps in history
setopt hist_expire_dups_first # expire duplicate entries first
setopt hist_ignore_dups       # ignore consecutive duplicates
setopt hist_ignore_space      # ignore commands starting with space
setopt hist_verify            # show expanded command before executing
setopt share_history          # share history across sessions

# --- Theme ---

# Powerlevel10k
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Plugins ---

# Auto-close matching delimiters in the shell editor
zinit light hlissner/zsh-autopair

# Syntax-highlighting for Zsh
zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# Fish-like autosuggestions for Zsh
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Additional completion definitions for Zsh
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# Multi-word, syntax-highlighted history searching for Zsh
# zinit ice wait lucid
# zinit light zdharma-continuum/history-search-multi-word

# Open the GitHub page or website for a repository
zinit ice wait lucid
zinit light paulirish/git-open

# Cache the output of an initialization command to speed up startup
zinit light mroth/evalcache

# Homebrew init with _evalcache. A tmux session inherits this from its parent.
if [[ -z ${TMUX:-} ]]; then
  if [[ -n ${HOMEBREW_PREFIX:-} && -x "$HOMEBREW_PREFIX/bin/brew" ]]; then
    _evalcache "$HOMEBREW_PREFIX/bin/brew" shellenv
  fi
fi

# Conda manages CONDA_PREFIX at runtime; CONDA_ROOT is the installation root.
conda_command=''
if [[ -n ${CONDA_ROOT:-} && -x "$CONDA_ROOT/bin/conda" ]]; then
  conda_command="$CONDA_ROOT/bin/conda"
fi
[[ -z $conda_command ]] || _evalcache "$conda_command" shell.zsh hook
unset conda_command

if [[ -n ${CONDA_ROOT:-} && -x "$CONDA_ROOT/bin/mamba" ]]; then
  _evalcache "$CONDA_ROOT/bin/mamba" shell hook --shell zsh
fi

# Direnv hook for project-local environments
(( $+commands[direnv] )) && _evalcache direnv hook zsh

# Zoxide for smarter directory jumping
(( $+commands[zoxide] )) && _evalcache zoxide init zsh

# Source fnm
# fnm is not used anymore; uncomment to re-enable.
# if [ -z "$TMUX" ]; then
#   [ -d "$HOME/.fnm" ] && export PATH="$HOME/.fnm:$PATH"
#   (( $+commands[fnm] )) && _evalcache fnm env --use-on-cd
# fi

# Oh My Zsh
# zinit snippet OMZL::completion.zsh  # completion defaults
# zinit snippet OMZL::spectrum.zsh    # color preview helpers: spectrum_ls / spectrum_bls

# zinit snippet OMZP::colorize        # colorized cat/less via ccat / cless
zinit snippet OMZP::command-not-found # missing-command suggestions
# zinit snippet OMZP::dotenv          # replaced by direnv hook
zinit snippet OMZP::extract           # extract archives via x / extract

# Plugins from Prezto (order matters)
zinit snippet PZT::modules/helper      # helper functions used by other Prezto modules
zinit snippet PZT::modules/gnu-utility # wrap GNU tools on non-GNU systems
zinit snippet PZT::modules/utility     # general aliases and utility functions
zinit snippet PZT::modules/completion  # Prezto completion setup and styles

# --- Atuin ---
# Atuin owns Ctrl-R history search.
(( $+commands[atuin] )) && _evalcache atuin init zsh

# --- Completion ---
# zinit ice wait lucid
# zinit light esc/conda-zsh-completion

# --- Scripts ---
# OMZP::autojump / mfaerevaag/wd were previous directory-jump helpers.
# Keep zoxide as the primary replacement.
# zinit snippet OMZP::autojump
# zinit ice wait lucid as"program" pick"wd.sh" mv"_wd.sh -> _wd" \
#   atload="wd() { . wd.sh }" \
#   atpull'!git reset --hard'
# zinit light mfaerevaag/wd

# --- Key-bindings ---
bindkey -M viins '^[p' up-line-or-search   # Alt+p for searching backward in history
bindkey -M viins '^[n' down-line-or-search # Alt+n for searching forward in history
bindkey -M viins '^[f' forward-word        # Alt+f for moving forward by word
bindkey -M viins '^[b' backward-word       # Alt+b for moving backward by word

# --- Aliases ---

# Proxy helpers. Override the host and ports in the machine-local ~/.zshenv.
set-proxy() {
  local host=${PROXY_HOST:-127.0.0.1}
  local http_port=${PROXY_HTTP_PORT:-7890}
  local socks_port=${PROXY_SOCKS_PORT:-$http_port}

  export http_proxy="http://${host}:${http_port}"
  export https_proxy=$http_proxy
  export all_proxy="socks5://${host}:${socks_port}"
}

unset-proxy() {
  unset http_proxy https_proxy all_proxy
}

# Rsync aliases
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"

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

# Use nvim or lvim for vim
(( ! $+commands[nvim] )) || alias vim='nvim'

# Use colored output for ls on both GNU and macOS/BSD systems.
if (( $+commands[gls] )); then
  alias ls='gls --color=auto'
elif [[ $OSTYPE == darwin* ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
