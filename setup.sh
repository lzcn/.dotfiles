#!/usr/bin/env bash
DOTFILES="$(pwd)"

source $DOTFILES/utils.sh

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
    echo -e $"\nUsage: $(basename "$0") {flake|git|shell|tmux|all}\n"
    exit 1
    ;;
esac

echo -e
success "Done."
