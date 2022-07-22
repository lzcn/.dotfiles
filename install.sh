#!/usr/bin/env bash
DOTFILES="$(pwd)"

source $DOTFILES/utils.sh

install_cargo() {
  title "Installing Cargo"
  curl https://sh.rustup.rs -sSf | sh
}

install_nvchad() {
  title "Installing Nvchad"
  git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
}

install_lvim() {
  title "Installing LunarVim"
  if command_exists lvim; then
    success "LunarVim already installed"
  else
    bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
  fi
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
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
  else
    success "Zinit already installed."
  fi
}

install_fnm() {
  title "Installing Fast Node Manager"
  if command_exists fnm; then
    success "FNM already installed"
  else
    curl -fsSL https://fnm.vercel.app/install | bash
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
  cargo)
    install_cargo
    ;;
  lvim)
    install_lvim
    ;;
  nvchad)
    install_nvchad
    ;;
  fnm)
    install_fnm
    ;;
  homebrew)
    install_homebrew
    ;;
  ohmyzsh)
    install_ohmyzsh
    ;;
  submodules)
    install_submodules
    ;;
  zinit)
    install_zinit
    ;;
  all)
    install_homebrew
    install_fnm
    install_submodules
    install_zinit
    ;;
  *)
    echo "Usage: $0 {cargo|lvim|nvchad|fnm|homebrew|ohmyzsh|submodules|zinit|all}"
    exit 1
    ;;
esac
