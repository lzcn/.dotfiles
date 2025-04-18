# Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Zinit ---
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# --- Opts ---
setopt interactive_comments

# --- Envs ---
# Only prepend ~/.local/bin to PATH if not in TMUX
if [ -z "$TMUX" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# --- Theme ---
# Powerlevel10k theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
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
# zinit ice wait lucid
# zinit light zdharma-continuum/history-search-multi-word

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

# Rbenv init with _evalcache_clear
# (( ! $+commands[rbenv] )) || _evalcache rbenv init -

# Load autojump plugin if installed
(( ! $+commands[autojump] )) || zinit snippet OMZP::autojump

# Source fnm
if [ -z "$TMUX" ]; then
  [ -d "$HOME/.fnm" ] && export PATH="$HOME/.fnm:$PATH"
  (( $+commands[fnm] )) && eval "$(fnm env --use-on-cd)"
fi

# Lib from Oh My Zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::spectrum.zsh
zinit snippet OMZL::history.zsh

# Plugins from Oh My Zsh
zinit wait lucid for \
    OMZP::colorize \
    OMZP::command-not-found \
    OMZP::dotenv \
    OMZP::extract
    # OMZP::fzf

# Plugins from Prezto: relative order is important
zinit snippet PZT::modules/helper
zinit snippet PZT::modules/gnu-utility
zinit snippet PZT::modules/utility
zinit snippet PZT::modules/completion

# Atuin
zinit ice wait lucid
zinit load ellie/atuin

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
function setup_keybindings_viins() {
  bindkey -M viins '^[p' up-line-or-search
  bindkey -M viins '^[n' down-line-or-search
  bindkey -M viins '^[f' forward-word
  bindkey -M viins '^[b' backward-word
}
setup_keybindings_viins

# --- Aliases ---

# Aliases for brew
alias bubu='brew update && brew outdated && brew upgrade && brew autoremove && brew cleanup'

# Aliases for rsync
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"

# Aliases for tmux
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tls='tmux list-sessions'
alias tlw='tmux list-windows'
alias tkss='tmux kill-session -t'

# Aliases for colorls
if (( $+commands[colorls] )); then
  alias cls='colorls'
  alias cll='colorls -l'
  alias cla='colorls -lAh'
fi

# Aliases for conda
alias sra='conda activate'
alias srd='conda deactivate'

# Alias for lazygit
alias lg='lazygit'

# Count number of files in current directory
alias cntfile='ls -1 | wc -l'

# Use nvim or lvim for vim
(( ! $+commands[nvim] )) || alias vim='nvim'

# Use colored output for ls
alias ls="ls --color=auto"
