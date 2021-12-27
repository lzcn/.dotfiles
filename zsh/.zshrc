# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## --- Zinit ---
# - To update Zinit, issue zinit self-update
# - To update all plugins, issue zinit update
# - To update only a single plugin, issue zinit update <plugin>
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/z-a-patch-dl \
    zdharma-continuum/z-a-bin-gem-node

### End of Zinit's installer chunk

## --- Oh My Zsh ---
if [[ -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]]; then
    export ZSH=$HOME/.oh-my-zsh
    # disable automatic updates
    zstyle ':omz:update' mode disabled  
    source $ZSH/oh-my-zsh.sh
fi

## --- Theme ---

# about: powerlevel10k theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

## --- Plugins ---

# about: syntax-highlighting for Zsh
zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# about: fish-like autosuggestions for Zsh
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# about: additional completion definitions for Zsh
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# about: multi-word, syntax highlighted history searching for Zsh
#
# usage: ctrl-r
zinit ice wait lucid
zinit light zdharma-continuum/history-search-multi-word

# about: cache the output of an initialization command to speed up startup
#
# usage: replace a specific init command, for example, `eval "$(hub alias -s)"`
#        with `_evalcache hub alias -s` in setup
#        to clear cache use `_evalcache_clear`
zinit light mroth/evalcache

# homebrew init with _evalcache
[[ ! -f $HOMEBREW_PREFIX/bin/brew ]] || _evalcache $HOMEBREW_PREFIX/bin/brew shellenv

# conda init with _evalcache
[[ ! -f $CONDA_PREFIX/bin/conda ]] || _evalcache $CONDA_PREFIX/bin/conda shell.zsh hook

# if rbenv is installed, initialize it
(( ! $+commands[rbenv] )) || _evalcache rbenv init -

# load autojump plugin if installed
(( ! $+commands[autojump] )) || zinit snippet OMZP::autojump

# plugins from Oy My Zsh
zinit wait lucid for \
    OMZP::brew \
    OMZP::colored-man-pages \
    OMZP::colorize \
    OMZP::command-not-found \
    OMZP::cp \
    OMZP::dotenv \
    OMZP::dircycle \
    OMZP::dirhistory \
    OMZP::extract \
    OMZP::fasd \
    OMZP::rsync \
    OMZP::gitignore \
    OMZP::history

# plugins from Prezto
# relative order is important
zinit snippet PZT::modules/helper
zinit snippet PZT::modules/gnu-utility
zinit snippet PZT::modules/utility
zinit snippet PZT::modules/completion
zinit wait lucid for \
    PZTM::command-not-found \
    PZTM::spectrum

## --- Completion ---


## --- Scripts ---

# about: an alternative to the cd
zplugin ice wait lucid as"program" pick"wd.sh" mv"_wd.sh -> _wd" \
  atload="wd() { . wd.sh }" \
  atpull'!git reset --hard'
zplugin light mfaerevaag/wd

## --- Aliases ---

# aliases for tmux
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tls='tmux list-sessions'
alias tlw='tmux list-windows'
alias tkss='tmux kill-session -t'

# aliases for colorls
alias cls='colorls'
alias cll='colorls -l'
alias cla='colorls -lAh'

# aliases for cluster-smi
alias csmi='cluster-smi'

# aliases for conda
alias sra='conda activate'
alias srd='conda deactivate'

# use neo-vim
alias vim='nvim'

## --- Others ---

# conda clobbers HOST, so we save the real hostname into another variable.
HOSTNAME="$(hostname)"

precmd() {
    OLDHOST="${HOST}"
    HOST="${HOSTNAME}"
}

preexec() {
    HOST="${OLDHOST}"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
