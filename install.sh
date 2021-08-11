#!/usr/bin/env bash

DOTFILES="$(pwd)"
COLOR_BLUE="\e[1;34m"
COLOR_GRAY="\e[1;38;5;243m"
COLOR_GREEN="\e[1;32m"
COLOR_NONE="\e[0m"
COLOR_PURPLE="\e[0;35m"
COLOR_RED="\e[0;31m"
COLOR_YELLOW="\e[0;33m"

title() {
    echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}====================${COLOR_NONE}\n"
}

question() {
    echo -e -n "${COLOR_YELLOW} [?] $1 (y/n): ${COLOR_NONE}"
    read -n 1 -r REPLY
    echo
}

warning() {
    echo -e "${COLOR_YELLOW} [!] $1${COLOR_NONE}"
}

info() {
    echo -e "${COLOR_BLUE} [*] $1${COLOR_NONE}"
}

fail() {
    echo -e "${COLOR_RED} [x] $1${COLOR_NONE}"
}

success() {
    echo -e "${COLOR_GREEN} [+] $1${COLOR_NONE}"
}

symlink() {
    target_file=$1
    source_file=$2
    if [ -e "$target_file" ]; then
        if [ "$(readlink "$target_file")" != "$source_file" ]; then
            question "'$target_file' already exists, do you want to overwrite it?"
            if [[ "$REPLY" =~ ^[Yy]$ ]]; then
                rm -rf "$target_file"
                info "remove $target_file"
                ln -fs $source_file $target_file
                info "$target_file -> $source_file"
            else
                fail "$target_file -> $source_file"
            fi
        else
            info "Found $target_file -> $source_file"
        fi
    else
        ln -fs $source_file $target_file
        success "Created $target_file -> $source_file"
    fi
}

is_osx() {
    [ $(uname) == "Darwin" ]
}

is_linux() {
    [ $(uname) == "Linux" ]
}

command_exists() {
    local command="$1"
    command -v "$command" &>/dev/null
}

setup_git() {
    title "Configuring Git"
    symlink $HOME/.gitalias $DOTFILES/git/.gitalias/gitalias.txt
    symlink $HOME/.gitconfig $DOTFILES/git/.gitconfig
    symlink $HOME/.gitignore_global $DOTFILES/git/.gitignore_global
    symlink $HOME/.git-commit-template $DOTFILES/git/.git-commit-template
}

setup_brew() {
    title "Installing Homebrew"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

setup_shell() {
    title "Configuring Shell"

    info "Installing Oh-My-Zsh ..."
    if [[ ! -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]]; then
        print -P "%F{33}▓▒░ %F{220}Installing %F{33}Oh My Zsh%F{220} Framework (%F{33}ohmyzsh/ohmyzsh%F{220})…%f"
        command sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" \
            --unattended --keep-zshrc &&
            print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" ||
            print -P "%F{160}▓▒░ The clone has failed.%f%b"
    else
        info "Found Oh-My-Zsh installed."
    fi

    info "Installing Zinit"
    if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
        print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
        command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
        command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" &&
            print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" ||
            print -P "%F{160}▓▒░ The clone has failed.%f%b"
    else
        info "Found Zinit installed."
    fi

    info "Setup dotfiles"
    symlink $HOME/.zshrc $DOTFILES/zsh/.zshrc

}

setup_tmux() {
    title "Configuring Tmux"
    symlink $HOME/.tmux.conf $DOTFILES/tmux/.tmux/.tmux.conf
    symlink $HOME/.tmux.conf.local $DOTFILES/tmux/.tmux.conf.local
}

case "$1" in
homebrew)
    setup_brew
    ;;
git)
    setup_git
    ;;
shell)
    setup_shell
    ;;
tmux)
    setup_tmux
    ;;
all)
    setup_brew
    setup_git
    setup_shell
    setup_tmux
    ;;
*)
    echo -e $"\nUsage: $(basename "$0") {brew|git|shell|tmux|all}\n"
    exit 1
    ;;
esac

echo -e
success "Done."
