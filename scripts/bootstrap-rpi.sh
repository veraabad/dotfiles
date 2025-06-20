#!/usr/bin/env bash
# @Author: Abad Vera
# @Date:   06/06/2020
# @Last Modified by:   Abad Vera
# @Last Modified time: 09/25/2020

# Installer for raspberry pi

# Go to dotfiles directory
cd "$(dirname $0)/.."

DOTFILES_DIR=$(pwd -P)
SCRIPT_DIR="scripts"
set -e

source ./$SCRIPT_DIR/print_source.sh
source ./$SCRIPT_DIR/common.sh

sudo apt-get update
# Install list of programs
< ./$SCRIPT_DIR/apt-get-list.txt xargs sudo apt-get install -y

# Update locale
# sudo sed -i 's/en_GB.UTF-8 UTF-8/# en_GB.UTF-8 UTF-8/g' /etc/locale.gen
sudo sed -i 's/# en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
sudo locale-gen en_US.UTF-8
sudo update-locale en_US.UTF-8

install_tmux_plugins
install_eza
install_pyenv_linux
install_starship_linux
install_neovim_latest

# Link dotfiles
install_dotfiles -r

# Set zsh as the default
check_default_shell
run_install -r
