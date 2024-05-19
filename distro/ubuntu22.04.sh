#!/usr/bin/env bash

# run_target_devbox() {
# }

# run_target_cargo() {
# }

run_target_apt() {
  sudo apt update
  sudo apt upgrade -y
  installs=(
    autotools-dev
    build-essential
    language-pack-ja
    fcitx-mozc
    software-properties-common
    openssh-server
    python3-pip
    python-is-python3
    zsh
  )
  for i in "${install[@]}"; do
    sudo apt install ${i} -y
  done
  sudo chsh ${USER} zsh
}

# run_target_nvm() {
# }

# run_target_config() {
# }
