#!/usr/bin/env bash
DOTFILES="$(pwd)"

source $DOTFILES/utils.sh

setup_env() {
    # Setup environment variables
    if ! check_string_in_file PATH=$DOTFILES/bin ~/.zshenv; then
        append_string_in_file "\nexport PATH=$DOTFILES/bin:\$PATH" ~/.zshenv
    fi
    if ! check_string_in_file HOMEBREW_PREFIX ~/.zshenv; then
        info 'Setup the $HOMEBREW_PREFIX or Skip (N)'
        read HOMEBREW_PREFIX
        while ! ([[ "$HOMEBREW_PREFIX" =~ ^[Nn]$ ]] || command_exists "$HOMEBREW_PREFIX/bin/brew"); do
            warning "$HOMEBREW_PREFIX/bin/brew not found"
            info 'Setup the $HOMEBREW_PREFIX or Skip (N)'
            read HOMEBREW_PREFIX
        done
        if command_exists "$HOMEBREW_PREFIX/bin/brew"; then
            info 'Added $HOMEBREW_PREFIX to .zshenv'
            append_string_in_file "\nexport HOMEBREW_PREFIX=$HOMEBREW_PREFIX" ~/.zshenv
        fi
    fi
    if ! check_string_in_file CONDA_PREFIX ~/.zshenv; then
        info 'Setup the $CONDA_PREFIX  or Skip (N)'
        read CONDA_PREFIX
        while ! ([[ "$CONDA_PREFIX" =~ ^[Nn]$ ]] || command_exists "$CONDA_PREFIX/bin/conda"); do
            warning "$CONDA_PREFIX/bin/conda not found"
            info 'Setup the $CONDA_PREFIX or Skip (N)'
            read CONDA_PREFIX
        done
        if command_exists "$CONDA_PREFIX/bin/conda"; then
            info 'Added $CONDA_PREFIX to .zshenv'
            append_string_in_file "\nexport CONDA_PREFIX=$CONDA_PREFIX" ~/.zshenv
        fi
    fi
}

setup_brew() {
    brew install bat git ncdu node tldr
    if is_linux; then
        brew install zsh
    elif is_osx; then
        brew install apparency blueutil mactex qlcolorcode qlimagesize qlmarkdown qlstephen qlvideo quicklook-json quicklookase suspicious-package
    fi
}

setup_git() {
    title "Configuring Git"
    symlink $HOME/.gitalias $DOTFILES/git/.gitalias/gitalias.txt
    symlink $HOME/.gitconfig $DOTFILES/git/.gitconfig
    symlink $HOME/.gitignore_global $DOTFILES/git/.gitignore_global
    symlink $HOME/.git-commit-template $DOTFILES/git/.git-commit-template
}

setup_zsh() {
    title "Configuring Zsh"
    # symlink $HOME/.zshenv $DOTFILES/zsh/.zshenv
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
env)
    setup_env
    ;;
flake)
    setup_flake
    ;;
git)
    setup_git
    ;;
tmux)
    setup_tmux
    ;;
zsh)
    setup_zsh
    ;;
all)
    setup_flake
    setup_git
    setup_zsh
    setup_tmux
    ;;
*)
    echo -e $"\nUsage: $(basename "$0") {brew|env|flake|git|tmux|zsh|all}\n"
    exit 1
    ;;
esac

echo -e
success "Done."
