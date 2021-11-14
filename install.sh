#!/usr/bin/env bash
DOTFILES="$(pwd)"

source $DOTFILES/utils.sh

install_homebrew() {
    title "Installing Homebrew"
    if command_exists brew; then
        success "Homebrew already installed"
    else
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

install_zinit() {
    title "Installing Zinit"
    if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/master/doc/install.sh)"
    else
        success "Zinit already installed."
    fi
}

install_ohmyzsh() {
    title "Installing Oh-My-Zsh"
    if [[ ! -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]]; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        success "Oh-My-Zsh already installed."
    fi

}

case "$1" in
homebrew)
    install_homebrew
    ;;
ohmyzsh)
    install_ohmyzsh
    ;;
zinit)
    install_zinit
    ;;
all)
    install_homebrew
    install_ohmyzsh
    install_zinit
    ;;
*)
    echo -e $"\nUsage: $(basename "$0") {homebrew|ohmyzsh|zinit|all}\n"
    exit 1
    ;;
esac

echo -e
success "Done."
