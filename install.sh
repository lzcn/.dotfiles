#!/usr/bin/env bash
DOTFILES="$(pwd)"

source $DOTFILES/utils.sh

install_nvim() {
    # install vim-plugin
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

}

install_homebrew() {
    title "Installing Homebrew"
    if command_exists brew; then
        success "Homebrew already installed"
    else
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

install_submodules() {
    title "Installing submodules"
    git submodule update --init --recursive
    success "Submodules installed"
}

install_zinit() {
    title "Installing Zinit"
    if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
        sh -c "$(curl -fsSL https://git.io/zinit-install)"
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
    install_submodules
    install_zinit
    ;;
*)
    echo -e $"\nUsage: $(basename "$0") {homebrew|ohmyzsh|zinit|all}\n"
    exit 1
    ;;
esac

echo -e
success "Done."
