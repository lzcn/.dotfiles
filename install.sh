#!/usr/bin/env bash
DOTFILES="$(pwd)"

source $DOTFILES/utils.sh

install_homebrew() {
    title "Installing Homebrew"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_zinit() {
    title "Installing Zinit"
    if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
        print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
        command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
        command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" &&
            print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" ||
            print -P "%F{160}▓▒░ The clone has failed.%f%b"
    else
        info "Found Zinit installed."
    fi
}

install_ohmyzsh() {
    title "Installing Oh-My-Zsh ..."
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
    symlink $HOME/.zshenv $DOTFILES/zsh/.zshenv
    symlink $HOME/.zshrc $DOTFILES/zsh/.zshrc
    symlink $HOME/.p10k.zsh $DOTFILES/zsh/.p10k.zsh

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
