#!/usr/bin/env bash

run_target_devbox() {
  curl -fsSL https://get.jetify.com/devbox | bash
  devbox global pull https://github.com/KazuyoshiAkiyama/devbox-global-config.git
  devbox global install

  # Post Funcs
  . <(devbox global shellenv --init-hook)
}

run_target_cargo() {
  rustup default stable
  rustup update
  installs=(
    rust-analysis
    rust-src
  )
  for i in "${installs[@]}"; do
    rustup component add ${i}
  done
}

run_target_apt() {
  sudo apt update
  sudo apt upgrade -y
}

run_target_nvm() {
  [ -d ${HOME}/.nvm ] || {
    git clone https://github.com/creationix/nvm.git $HOME/.nvm
  }
  . $HOME/.nvm/nvm.sh
  nvm install --lts --no-progress
  source ${HOME}/.nvm/nvm.sh
  installs=(
    bash-language-server
    typescript-language-server
    vscode-html-languageserver-bin
  )
  for i in "${installs[@]}"; do
    npm install -g $i
  done
}

run_target_config() {
  CONFIG_DIR="${1}"
  XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
  # tmux
  printf "tmux configuration..."
  mkdir ${XDG_CONFIG_HOME}/tmux -p
  cp ${CONFIG_DIR}/tmux/* ${XDG_CONFIG_HOME}/tmux
  ln -fsr ${XDG_CONFIG_HOME}/tmux/tmux.conf ${HOME}/.tmux.conf
  mkdir -p ${XDG_CONFIG_HOME}/tmux/plugins
  [ -d ${XDG_CONFIG_HOME}/tmux/plugins/tpm ] || {
    git clone https://github.com/tmux-plugins/tpm ${XDG_CONFIG_HOME}/tmux/plugins/tpm
    ${XDG_CONFIG_HOME}/tmux/plugins/tpm/scripts/install_plugins.sh
  }
  echo "done."
  echo "please see ${XDG_CONFIG_HOME}/tmux"
  echo ""

  # nvim
  printf "nvim configuration..."
  mkdir ${XDG_CONFIG_HOME}/nvim -p
  cp ${CONFIG_DIR}/vim/* ${XDG_CONFIG_HOME}/nvim
  echo "done."
  echo "please see ${XDG_CONFIG_HOME}/nvim"
  echo ""

  # vim
  printf "vim configuration..."
  [ -e ${XDG_CONFIG_HOME}/vim ] || {
    ln -fsr ${XDG_CONFIG_HOME}/nvim ${XDG_CONFIG_HOME}/vim
  }
  echo "done."
  echo "please see ${XDG_CONFIG_HOME}/vim"
  echo ""

  # tig
  printf "tig configuration..."
  cp ${CONFIG_DIR}/tig/tigrc ${HOME}/.tigrc
  echo "done."
  echo "please see ${HOME}/.tigrc"
  echo ""

  # procs
  printf "procs configuration..."
  mkdir ${XDG_CONFIG_HOME}/procs -p
  cp ${CONFIG_DIR}/procs/* ${XDG_CONFIG_HOME}/procs
  echo "done."
  echo "please see ${XDG_CONFIG_HOME}/procs"
  echo ""

  # bash
  printf "bash configuration..."
  echo '[ -f ${HOME}/.nvm/nvm.sh ] && source ${HOME}/.nvm/nvm.sh' >> ${HOME}/.bashrc
  echo 'eval "$(devbox global shellenv --init-hook)"' >> ${HOME}/.bashrc
  echo "done."
  echo "please see ${HOME}/.bashrc"
  echo ""

  # zsh
  printf "zsh configuration..."
  mkdir ${XDG_CONFIG_HOME}/zsh -p
  cp ${CONFIG_DIR}/zsh/* ${XDG_CONFIG_HOME}/zsh
  ln -sfr ${XDG_CONFIG_HOME}/zsh/zshrc ${HOME}/.zshrc
  mkdir ${XDG_CONFIG_HOME}/sheldon -p
  cp ${CONFIG_DIR}/sheldon/* ${XDG_CONFIG_HOME}/sheldon
  echo "done."
  echo "please see ${XDG_CONFIG_HOME}/zsh"
  echo "please see ${XDG_CONFIG_HOME}/sheldon"
  echo ""

  # ranger
  printf "ranger configuration..."
  mkdir ${XDG_CONFIG_HOME}/ranger -p
  cp ${CONFIG_DIR}/ranger/* ${XDG_CONFIG_HOME}/ranger
  echo "done."
  echo "please see ${XDG_CONFIG_HOME}/ranger"
  echo ""
}
