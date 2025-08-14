#!/usr/bin/env bash

set -e

run_target_apt() {
  sudo apt update
  sudo apt upgrade -y
}

run_target_cargo() {
  info "Install cargo/rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
  rustup default stable > /dev/null
  rustup update > /dev/null
  installs=(
    rust-analysis
    rust-analyzer
    rust-src
  )
  for i in "${installs[@]}"; do
    info "install rustup component ${i}"
    rustup component add ${i} > /dev/null
    success "install ${i}"
  done

  installs=(
    sheldon
    eza
    bat
    procs
  )
  for i in "${installs[@]}"; do
    info "install ${i} with cargo"
    cargo install "${i}" > /dev/null
    success "install ${i}"
  done
}

run_target_github() {
  info "Setup git user"
  if [[ $- == *i* ]]; then
    read -p "${CIAN}Input Git User: ${END}" git_user
    read -p "${CIAN}Input Git mail: ${END}" git_email
  else
    git_user="John Doe"
    git_email="placeholder@mail"
  fi

  git config --global user.name "$git_user"
  git config --global user.email "$git_email"
  success "Setup git user"

  info "setup github cli"
  gh auth login
  success "setup github cli"

  mkdir -p ~/.local/bin
  # install tmux
  info "install tmux to ~/.local/bin ..."
  ver=$(gh release view --repo nelsonenzo/tmux-appimage --json tagName -q ".tagName")
  gh release download "$ver" --repo nelsonenzo/tmux-appimage --pattern 'tmux.appimage' --dir ~/.local/bin
  mv ~/.local/bin/tmux.appimage ~/.local/bin/tmux
  chmod +x ~/.local/bin/tmux
  success "install tmux"

  # install neovim
  info "install neovim to ~/.local/bin ..."
  ver=$(gh release view --repo neovim/neovim --json tagName -q ".tagName")
  gh release download "$ver" --repo neovim/neovim --pattern 'nvim-linux-x86_64.appimage' --dir ~/.local/bin
  mv ~/.local/bin/nvim-linux-x86_64.appimage ~/.local/bin/nvim
  chmod +x ~/.local/bin/nvim
  success "install neovim"

  warn "Please run \`gh auth login\` after this sequence finish"
}

run_target_uv() {
  info "install uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  success "install uv"
}

run_target_nvm() {
  info "install nvm"
  [ -d ${HOME}/.nvm ] || {
    git clone https://github.com/creationix/nvm.git $HOME/.nvm
  }
  . $HOME/.nvm/nvm.sh
  nvm install --lts --no-progress
  source ${HOME}/.nvm/nvm.sh
  nvm use --lts
  success "install nvm"

  info "install npm packages"
  installs=(
    bash-language-server
    typescript-language-server
    vscode-html-languageserver-bin
  )
  for i in "${installs[@]}"; do
    npm install -g $i
  done
  success "install npm packages"
}

run_target_config() {
  CONFIG_DIR="${1}"
  XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
  # tmux
  info "setup tmux config..."
  mkdir ${XDG_CONFIG_HOME}/tmux -p
  cp ${CONFIG_DIR}/tmux/* ${XDG_CONFIG_HOME}/tmux
  ln -fsr ${XDG_CONFIG_HOME}/tmux/tmux.conf ${HOME}/.tmux.conf
  mkdir -p ${XDG_CONFIG_HOME}/tmux/plugins
  [ -d ${XDG_CONFIG_HOME}/tmux/plugins/tpm ] || {
    git clone https://github.com/tmux-plugins/tpm ${XDG_CONFIG_HOME}/tmux/plugins/tpm
    ${XDG_CONFIG_HOME}/tmux/plugins/tpm/scripts/install_plugins.sh
  }
  success "setup tmux config. please see ${XDG_CONFIG_HOME}/tmux"
  echo ""

  # nvim
  info "setup nvim config..."
  mkdir ${XDG_CONFIG_HOME}/nvim -p
  cp ${CONFIG_DIR}/vim/* ${XDG_CONFIG_HOME}/nvim
  success "setup nvim config. please see ${XDG_CONFIG_HOME}/nvim"
  echo ""

  # vim
  info "setup vim config..."
  [ -e ${XDG_CONFIG_HOME}/vim ] || {
    ln -fsr ${XDG_CONFIG_HOME}/nvim ${XDG_CONFIG_HOME}/vim
  }
  success "setup vim config. please see ${XDG_CONFIG_HOME}/vim"
  echo ""

  # tig
  info "setup tig config..."
  cp ${CONFIG_DIR}/tig/tigrc ${HOME}/.tigrc
  success "setup tig config. lease see ${HOME}/.tigrc"
  echo ""

  # procs
  info "setup procs config..."
  mkdir ${XDG_CONFIG_HOME}/procs -p
  cp ${CONFIG_DIR}/procs/* ${XDG_CONFIG_HOME}/procs
  success "setup procs config. please see ${XDG_CONFIG_HOME}/procs"
  echo ""

  # bash
  info "setup bash config..."
  echo '[ -f ${HOME}/.nvm/nvm.sh ] && source ${HOME}/.nvm/nvm.sh' >> ${HOME}/.bashrc
  success "setup bash config. please see ${HOME}/.bashrc"
  echo ""

  # zsh
  info "setup zsh config..."
  mkdir ${XDG_CONFIG_HOME}/zsh -p
  cp ${CONFIG_DIR}/zsh/* ${XDG_CONFIG_HOME}/zsh
  ln -sfr ${XDG_CONFIG_HOME}/zsh/zshrc ${HOME}/.zshrc
  mkdir ${XDG_CONFIG_HOME}/sheldon -p
  cp ${CONFIG_DIR}/sheldon/* ${XDG_CONFIG_HOME}/sheldon
  sudo chsh ${USER} -s /bin/zsh
  success "setup zsh config. please see ${XDG_CONFIG_HOME}/zsh and ${XDG_CONFIG_HOME}/sheldon"
  echo ""

  # ranger
  info "setup ranger config..."
  mkdir ${XDG_CONFIG_HOME}/ranger -p
  cp ${CONFIG_DIR}/ranger/* ${XDG_CONFIG_HOME}/ranger
  success "setup ranger config. please see ${XDG_CONFIG_HOME}/ranger"
  echo ""

  # git
  info "setup git config..."
  mkdir ${XDG_CONFIG_HOME}/git -p
  cp ${CONFIG_DIR}/git/* ${XDG_CONFIG_HOME}/git
  git config --global commit.template ~/.gitmessage.txt
  git config --global core.editor "nvim"
  git config --global color.ui auto
  git config --global core.autocrlf input
  git config --global core.safecrlf true
  git config --global alias.st status
  git config --global alias.co checkout
  git config --global alias.cob "checkout -b"
  git config --global alias.br branch
  git config --global alias.cm "commit -s"
  git config --global alias.l "log --oneline --graph --decorate --all"
  success "setup git config. please see ${XDG_CONFIG_HOME}/git"
  echo ""
}
