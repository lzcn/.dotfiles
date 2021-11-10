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
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/master/doc/install.sh)"
    else
        info "Found Zinit installed."
    fi
}

install_ohmyzsh() {
    title "Installing Oh-My-Zsh ..."
    if [[ ! -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]]; then
        info "Installing Oh My Zsh Framework ohmyzsh/ohmyzsh…"
        command sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" \
            --unattended --keep-zshrc &&
            info "Installation successful." ||
            info "The clone has failed."
    else
        info "Found Oh-My-Zsh installed."
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
