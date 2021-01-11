# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## Zinit
# - To update Zinit, issue zinit self-update
# - To update all plugins, issue zinit update
# - To update only a single plugin, issue zinit update NAME

### Added by Zinit's installer
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
### End of Zinit's installer chunk

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
# usage: Ctrl-R
zinit ice wait lucid
zinit light zdharma/history-search-multi-word

# about: cache the output of an initialization command to speed up startup
#
# usage: replace a specific init command, for example, `eval "$(hub alias -s)"`
#        with `_evalcache hub alias -s` in setup
#        to clear cache use `_evalcache_clear`
zinit light mroth/evalcache

# about: rbenv init with Zinit
export PATH="$HOME/.rbenv/bin:$PATH"
zinit ice wait lucid
zinit load htlsne/zplugin-rbenv

# plugins from Oy My Zsh
zinit wait lucid for \
    OMZP::autojump \
    OMZP::colored-man-pages \
    OMZP::colorize \
    OMZP::command-not-found \
    OMZP::cp \
    OMZP::dircycle \
    OMZP::dirhistory \
    OMZP::dotenv \
    OMZP::extract \
    OMZP::fasd \
    OMZP::gitignore \
    OMZP::history

# plugins from Prezto
zinit wait lucid for \
    PZTM::utility \
    PZTM::spectrum

## --- Snippets ---

# git aliases that used by Oh My ZSH
zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git

# autojump configuration to source
zinit ice wait lucid
zinit snippet https://github.com/wting/autojump/blob/master/bin/autojump.zsh

## --- Completion ---

zinit snippet https://github.com/ThiefMaster/zsh-config/blob/master/zshrc.d/completion.zsh

zinit ice wait lucid as"completion"
zinit snippet https://github.com/zsh-users/zsh/blob/master/Completion/Unix/Command/_tmux

zinit ice wait lucid as"completion"
zinit snippet https://github.com/esc/conda-zsh-completion/blob/master/_conda

zinit ice wait lucid as"completion"
zinit snippet OMZP::fd/_fd

zinit ice wait lucid as"completion"
zinit snippet OMZP::docker/_docker

## --- Scripts ---

# about: a collection of extension:color mappings
# ogham/exa also uses the definitions
zinit ice wait"0c" lucid reset \
    atclone"local P=${${(M)OSTYPE:#*darwin*}:+g}
            \${P}sed -i \
            '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
            \${P}dircolors -b LS_COLORS > c.zsh" \
    atpull'%atclone' pick"c.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

# about: 
zplugin ice wait lucid as"program" pick"wd.sh" mv"_wd.sh -> _wd" \
  atload="wd() { . wd.sh }" \
  atpull'!git reset --hard'
zplugin light mfaerevaag/wd

## --- Oh My Zsh ---
if [[ ! -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}Oh My Zsh%F{220} Framework (%F{33}ohmyzsh/ohmyzsh%F{220})…%f"
    command sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" \
    --unattended --keep-zshrc && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

## --- Customization ---

# homebrew init with _evalcache
if [[ -f $HOME/.linuxbrew/bin/brew ]]; then
  _evalcache $HOME/.linuxbrew/bin/brew shellenv
elif [[ -f $HOME/../linuxbrew/.linuxbrew/bin/brew ]]; then
  _evalcache $HOME/../linuxbrew/.linuxbrew/bin/brew shellenv
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  _evalcache /home/linuxbrew/.linuxbrew/bin/brew shellenv
elif [[ -f /usr/local/bin/brew ]]; then
  _evalcache /usr/local/bin/brew shellenv
fi

# conda init with _evalcache
if [[ -f $HOME/miniconda/bin/conda ]]; then
  _evalcache $HOME/miniconda/bin/conda shell.zsh hook
elif [[ -f $HOME/anaconda/bin/conda ]]; then
  _evalcache $HOME/anaconda/bin/conda shell.zsh hook
fi

# conda clobbers HOST, so we save the real hostname into another variable.
HOSTNAME="$(hostname)"

precmd() {
    OLDHOST="${HOST}"
    HOST="${HOSTNAME}"
}

preexec() {
    HOST="${OLDHOST}"
}

export PATH="$HOME/bin:$PATH"
# TODO: check before export
export PATH="/usr/local/texlive/2020/bin/x86_64-linux:$PATH"

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

## --- Theme ---

# about: powerlevel10k theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
