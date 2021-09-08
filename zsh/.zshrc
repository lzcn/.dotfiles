# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## --- Zinit ---
# - To update Zinit, issue zinit self-update
# - To update all plugins, issue zinit update
# - To update only a single plugin, issue zinit update <plugin>
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## --- Oh My Zsh ---
[[ ! -d $HOME/.oh-my-zsh ]] || export ZSH=$HOME/.oh-my-zsh && source $ZSH/oh-my-zsh.sh

## --- Theme ---

# about: powerlevel10k theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

## --- Plugins ---

# about: syntax-highlighting for Zsh
zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light zdharma/fast-syntax-highlighting

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
zinit light zdharma/history-search-multi-word

# about: cache the output of an initialization command to speed up startup
#
# usage: replace a specific init command, for example, `eval "$(hub alias -s)"`
#        with `_evalcache hub alias -s` in setup
#        to clear cache use `_evalcache_clear`
zinit light mroth/evalcache

# plugins from Oy My Zsh
zinit wait lucid for \
    OMZP::autojump \
    OMZP::brew \
    OMZP::colored-man-pages \
    OMZP::colorize \
    OMZP::command-not-found \
    OMZP::cp \
    OMZP::dircycle \
    OMZP::dirhistory \
    OMZP::dotenv \
    OMZP::extract \
    OMZP::fasd \
    OMZP::rsync \
    OMZP::gitignore \
    OMZP::history

# plugins from Prezto
zinit wait lucid for \
    PZTM::utility \
    PZTM::spectrum

## --- Snippets ---


## --- Completion ---


## --- Scripts ---

# about: an alternative to the cd
zplugin ice wait lucid as"program" pick"wd.sh" mv"_wd.sh -> _wd" \
  atload="wd() { . wd.sh }" \
  atpull'!git reset --hard'
zplugin light mfaerevaag/wd

## --- Customization ---

# homebrew init with _evalcache
[[ ! -f $HOMEBREW_PREFIX/bin/brew ]] || _evalcache $HOMEBREW_PREFIX/bin/brew shellenv

# conda init with _evalcache
[[ ! -f $CONDA_PREFIX/bin/conda ]] || _evalcache $CONDA_PREFIX/bin/conda shell.zsh hook

# rbenv init with _evalcache
[[ ! -f $HOME/.rbenv/bin ]] ||  export PATH="$HOME/.rbenv/bin:$PATH"
! command -v "rbenv" &>/dev/null  || _evalcache rbenv init -

# conda clobbers HOST, so we save the real hostname into another variable.
HOSTNAME="$(hostname)"

precmd() {
    OLDHOST="${HOST}"
    HOST="${HOSTNAME}"
}

preexec() {
    HOST="${OLDHOST}"
}

# path
export PATH="$HOME/bin:$PATH"

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
