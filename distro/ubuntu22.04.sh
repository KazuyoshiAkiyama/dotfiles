#!/usr/bin/env bash

set -e

run_target_apt() {
  sudo apt update > /dev/null
  sudo apt upgrade -y > /dev/null
  installs=(
    vim
    neovim
    sudo
    git
    tmux
    autoconf
    automake
    ripgrep
    fd-find
    binutils
    m4
    cmake
    cscope
    universal-ctags
    highlight
    screen
    tcpdump
    llvm
    golang
    fzf
    fzy
    curl
    imagemagick
    w3m
    wget
    tig
    ranger
    autojump
    fasd
    peco
    autotools-dev
    build-essential
    pkg-config
    ninja-build
    flex
    bison
    libtool
    libtool-bin
    googletest
    unzip
    dnsutils
    diffutils
    gzip
    bzip2
    pbzip2
    pigz
    pixz
    cpio
    rsync
    bc
    jq
    findutils
    language-pack-ja
    fcitx-mozc
    software-properties-common
    lsb-release
    gnupg
    xsel
    ca-certificates
    openssh-server
    python3-pip
    python-is-python3
    zsh
    libssl-dev
  )
  export DEBIAN_FRONTEND=noninteractive
  info "install ${installs[@]} with apt"
  sudo apt install -y "${installs[@]}" > /dev/null
  success "install ${installs[@]}"

  # docker install
  info "install docker with apt"
  sudo mkdir -m 0755 -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt update > /dev/null
  installs=(
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    docker-compose-plugin
  )
  sudo apt install -y "${installs[@]}" > /dev/null
  [ "$(getent group docker)" ] || {
    sudo groupadd docker
  }
  sudo usermod -aG docker ${USER:-user}
  success "install docker"

  # install gh
  info "install github cli with apt"
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo dd of=/etc/apt/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
  
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  
  sudo apt update > /dev/null
  sudo apt install -y gh > /dev/null
  success "install github cli"

  info "cleanup apt"
  sudo apt autoremove > /dev/null
  sudo apt clean > /dev/null
  success "cleanup apt"
}

# run_target_cargo() {
# }
#
# run_target_uv() {
# }

# run_target_nvm() {
# }

# run_target_config() {
# }
