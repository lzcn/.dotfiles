#!/usr/bin/env bash
DOTFILES="$(pwd)"

source $DOTFILES/utils.sh

setup_brew() {
    brew install \
        bat \
        git \
        ncdu \
        node \
        tldr
    if is_linux; then
        brew install zsh
    fi
    if is_osx; then
        brew install \
            anki \
            apparency \
            atext \
            blueutil \
            calibre \
            clash-for-windows \
            iina \
            jabref \
            karabiner-elements \
            kindle \
            latexit \
            macfuse \
            mactex \
            mathpix-snipping-tool \
            microsoft-auto-update \
            microsoft-remote-desktop \
            miniconda \
            pdf-expert \
            qlcolorcode \
            qlimagesize \
            qlmarkdown \
            qlstephen \
            qlvideo \
            quicklook-json \
            quicklookase \
            suspicious-package \
            synergy \
            tencent-lemon \
            texstudio \
            xpra \
            xquartz
    fi
}

setup_git() {
    title "Configuring Git"
    symlink $HOME/.gitalias $DOTFILES/git/.gitalias/gitalias.txt
    symlink $HOME/.gitconfig $DOTFILES/git/.gitconfig
    symlink $HOME/.gitignore_global $DOTFILES/git/.gitignore_global
    symlink $HOME/.git-commit-template $DOTFILES/git/.git-commit-template
}

setup_shell() {
    title "Configuring Shell"
    symlink $HOME/.zshenv $DOTFILES/zsh/.zshenv
    symlink $HOME/.zshrc $DOTFILES/zsh/.zshrc
    symlink $HOME/.p10k.zsh $DOTFILES/zsh/.p10k.zsh

}

setup_tmux() {
    title "Configuring Tmux"
    symlink $HOME/.tmux.conf $DOTFILES/tmux/.tmux/.tmux.conf
    symlink $HOME/.tmux.conf.local $DOTFILES/tmux/.tmux.conf.local
}

setup_flake() {
    title "Configuring flake"
    symlink $HOME/.config/flake8 $DOTFILES/config/flake8
}

case "$1" in
brew)
    setup_brew
    ;;
flake)
    setup_flake
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
    setup_flake
    setup_git
    setup_shell
    setup_tmux
    ;;
*)
    echo -e $"\nUsage: $(basename "$0") {brew|flake|git|shell|tmux|all}\n"
    exit 1
    ;;
esac

echo -e
success "Done."
