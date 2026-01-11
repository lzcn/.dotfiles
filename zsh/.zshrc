# --- Powerlevel10k instant prompt ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Zinit ---
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# --- Opts ---
setopt interactive_comments

# --- History configuration
[[ -z "$HISTFILE" ]] && HISTFILE="$HOME/.zsh_history"
(( HISTSIZE < 50000 )) && HISTSIZE=50000
(( SAVEHIST < 10000 )) && SAVEHIST=10000

setopt extended_history       # record timestamps in history
setopt hist_expire_dups_first # expire duplicate entries first
setopt hist_ignore_dups       # ignore consecutive duplicates
setopt hist_ignore_space      # ignore commands starting with space
setopt hist_verify            # show expanded command before executing
setopt share_history          # share history across sessions

# --- Envs ---
# Only prepend ~/.local/bin to PATH if not in TMUX
if [ -z "$TMUX" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# --- Theme ---

# Powerlevel10k
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Plugins ---

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
zinit ice wait lucid
zinit light zdharma-continuum/history-search-multi-word

# Open the GitHub page or website for a repository
zinit ice wait lucid
zinit light paulirish/git-open

# Cache the output of an initialization command to speed up startup
zinit light mroth/evalcache

# Command-line fuzzy finder
zinit light junegunn/fzf
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# Homebrew init with _evalcache
[ -n "$TMUX" ] || [ ! -f "$HOMEBREW_PREFIX/bin/brew" ] || _evalcache "$HOMEBREW_PREFIX/bin/brew" shellenv

# Conda init with _evalcache
[ ! -f "$CONDA_PREFIX/bin/conda" ] || _evalcache "$CONDA_PREFIX/bin/conda" shell.zsh hook

# Mamba init with _evalcache
[ ! -f "$CONDA_PREFIX/bin/mamba" ] || _evalcache "$CONDA_PREFIX/bin/mamba" shell hook --shell zsh

# Load autojump plugin if installed
(( ! $+commands[autojump] )) || zinit snippet OMZP::autojump

# Source fnm
if [ -z "$TMUX" ]; then
  [ -d "$HOME/.fnm" ] && export PATH="$HOME/.fnm:$PATH"
  (( $+commands[fnm] )) && _evalcache fnm env --use-on-cd
fi

# Oh My Zsh libs
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::spectrum.zsh

# Plugins from Oh My Zsh
zinit wait lucid for \
    OMZP::colorize \
    OMZP::command-not-found \
    OMZP::dotenv \
    OMZP::extract
    # OMZP::fzf

# Plugins from Prezto (order matters)
zinit snippet PZT::modules/helper
zinit snippet PZT::modules/gnu-utility
zinit snippet PZT::modules/utility
zinit snippet PZT::modules/completion

# --- Atuin ---
# zinit ice wait lucid
# zinit load atuinsh/atuin
export ATUIN_NOBIND="true"
_evalcache atuin init zsh

# --- Completion ---
# zinit ice wait lucid
# zinit light esc/conda-zsh-completion

# --- Scripts ---
# An alternative to the cd
zinit ice wait lucid as"program" pick"wd.sh" mv"_wd.sh -> _wd" \
  atload="wd() { . wd.sh }" \
  atpull'!git reset --hard'
zinit light mfaerevaag/wd

# --- Key-bindings ---
bindkey -M viins '^[p' up-line-or-search   # Alt+p for searching backward in history
bindkey -M viins '^[n' down-line-or-search # Alt+n for searching forward in history
bindkey -M viins '^[f' forward-word        # Alt+f for moving forward by word
bindkey -M viins '^[b' backward-word       # Alt+b for moving backward by word

bindkey '^[[A' _atuin_search_widget        # Up arrow for atuin history search

# --- Aliases ---

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

# Use colored output for ls
alias ls="ls --color=auto"
