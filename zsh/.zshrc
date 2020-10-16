# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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

## Plugins for Zinit

# about: cache the output of an initialization command to speed up startup
#
# usage: replace a specific init command, for example, `eval "$(hub alias -s)"`
#        with `_evalcache hub alias -s` in setup
#        to clear cache use `_evalcache_clear`
zplugin light mroth/evalcache

# about: rbenv init with Zinit
export PATH="$HOME/.rbenv/bin:$PATH"
zinit ice wait lucid
zinit load htlsne/zplugin-rbenv

# about: conda init with Zinit
CONDA_PREFIX=$HOME/miniconda
zinit ice wait lucid
zinit load lzcn/zplugin-conda-init

# about: multi-word, syntax highlighted history searching for Zsh
#
# usage: Ctrl-R
zinit ice wait lucid
zinit load zdharma/history-search-multi-word

# about: fish-like autosuggestions for Zsh
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit load zsh-users/zsh-autosuggestions

# about: syntax-highlighting for Zsh
zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit load zdharma/fast-syntax-highlighting

# about: additional completion definitions for Zsh
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit load zsh-users/zsh-completions

## Plugins from Oy My Zsh
zinit wait lucid for \
    OMZ::plugins/autojump/autojump.plugin.zsh \
    OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh \
    OMZ::plugins/colorize/colorize.plugin.zsh \
    OMZ::plugins/command-not-found/command-not-found.plugin.zsh \
    OMZ::plugins/cp/cp.plugin.zsh \
    OMZ::plugins/dirhistory/dirhistory.plugin.zsh \
    OMZ::plugins/extract/extract.plugin.zsh \
    OMZ::plugins/fasd/fasd.plugin.zsh \
    OMZ::plugins/gitignore/gitignore.plugin.zsh \
    OMZ::plugins/history/history.plugin.zsh \
    OMZ::plugins/tmux/tmux.plugin.zsh \
    OMZ::plugins/screen/screen.plugin.zsh

## Completion for Zinit

zinit ice as"completion"
zinit snippet https://github.com/zsh-users/zsh/blob/master/Completion/Unix/Command/_tmux

zinit wait lucid for \
    as"completion" \
          OMZP::docker/_docker \
          OMZP::fd/_fd

# HOMEBRE shellenv
if [[ -f $HOME/.linuxbrew/bin/brew ]]; then
  _evalcache $HOME/.linuxbrew/bin/brew shellenv
elif [[ -f $HOME/../linuxbrew/.linuxbrew/bin/brew ]]; then
  _evalcache $HOME/../linuxbrew/.linuxbrew/bin/brew shellenv
elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  _evalcache /home/linuxbrew/.linuxbrew/bin/brew shellenv
elif [[ -f /usr/local/bin/brew ]]; then
  _evalcache /usr/local/bin/brew shellenv
fi

# function for activate/deactivate conda env
sra() {
  conda activate $1
  if [ -z "$_LD_LIBRARY_PATH" ]
  then
    export _LD_LIBRARY_PATH=$LD_LIBRARY_PATH
  fi
  export LD_LIBRARY_PATH="$CONDA_PREFIX/envs/$1/lib:$LD_LIBRARY_PATH"
}
srd() {
  conda deactivate
  export LD_LIBRARY_PATH=$_LD_LIBRARY_PATH
  unset _LD_LIBRARY_PATH
}

# Conda clobbers HOST, so we save the real hostname into another variable.
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

# aliases
alias cls='colorls'
alias cll='colorls -l'
alias cla='colorls -lAh'
alias watch-gpu='watch -n 0.1 nvidia-smi'

# TODO: better alias
alias csmi='LD_LIBRARY_PATH="/usr/local/zeromq-4.1.0/dist/lib:$LD_LIBRARY_PATH" $HOME/go/src/cluster-smi/cluster-smi -p'

## Handy Tools

# autojump configuration - add this to ~/.zshrc
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
