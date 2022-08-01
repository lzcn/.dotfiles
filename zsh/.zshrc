# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"

# Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## --- Zinit ---
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## --- Envs ---
[[ ! -z $TMUX ]] || export PATH="$HOME/.local/bin":$PATH

## --- Theme ---

# about: powerlevel10k theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

## --- Plugins ---

# about: vim-mode for zsh
# configuration for vim-mode
ZVM_VI_EDITOR=lvim
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
zinit ice depth=1; zinit light jeffreytse/zsh-vi-mode

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
[[ ! -z $TMUX ]] || [[ ! -f $HOMEBREW_PREFIX/bin/brew ]] || _evalcache $HOMEBREW_PREFIX/bin/brew shellenv

# conda init with _evalcache
[[ ! -f $CONDA_PREFIX/bin/conda ]] || _evalcache $CONDA_PREFIX/bin/conda shell.zsh hook

# rbenv init with _evalcache_clear
(( ! $+commands[rbenv] )) || _evalcache rbenv init -

# load autojump plugin if installed
(( ! $+commands[autojump] )) || zinit snippet OMZP::autojump

# source fnm
[[ ! -z $TMUX ]] || [[ ! -d $HOME/.fnm ]] || export PATH=$HOME/.fnm:$PATH
[[ ! -z $TMUX ]] || (( ! $+commands[fnm] )) || eval "$(fnm env --use-on-cd)"

# lib from Oy My Zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::spectrum.zsh
zinit snippet OMZL::history.zsh
zinit snippet OMZL::termsupport.zsh

# plugins from Oy My Zsh
# TODO: move necessary aliases to zshrc 
zinit wait lucid for \
    OMZP::brew \
    OMZP::colored-man-pages \
    OMZP::colorize \
    OMZP::command-not-found \
    OMZP::dotenv \
    OMZP::dirhistory \
    OMZP::extract \
    OMZP::fzf \
    OMZP::rsync

# plugins from Prezto: relative order is important
# TODO: move necessary parts to zshrc
zinit snippet PZT::modules/helper
zinit snippet PZT::modules/gnu-utility
zinit snippet PZT::modules/utility
zinit snippet PZT::modules/completion

# atuin
zinit ice wait lucid
zinit load ellie/atuin

## --- Completion ---

zinit ice wait lucid
zinit light esc/conda-zsh-completion

## --- Scripts ---

# about: an alternative to the cd
zinit ice wait lucid as"program" pick"wd.sh" mv"_wd.sh -> _wd" \
  atload="wd() { . wd.sh }" \
  atpull'!git reset --hard'
zinit light mfaerevaag/wd

## --- key-bindings ---

bindkey -M viins '^[p' up-line-or-search
bindkey -M viins '^[n' down-line-or-search
bindkey -M viins '^[f' forward-word
bindkey -M viins '^[b' backward-word

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

alias lg='lazygit'

# use nvim or lvim for vim
(( ! $+commands[nvim] )) || alias vim='nvim'
(( ! $+commands[nvim] )) || (( ! $+commands[lvim] )) || alias vim='lvim'

alias ls="ls --color=auto"

## --- Others ---

# git-mirror set/unset local/global
git-mirror () {
    if [[ $1 == "set" ]] then
      opt="" 
    else
      opt="--unset"
    fi
    git config $opt --$2 url."https://hub.fastgit.xyz/".insteadOf "https://github.com/"
}

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"
