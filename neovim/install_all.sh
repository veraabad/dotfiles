#!/usr/bin/env bash
NVIM_CUSTOM=~/.config/nvim-custom
export NVIM_CUSTOM

rm -rf $NVIM_CUSTOM

mkdir -p $NVIM_CUSTOM/share
mkdir -p $NVIM_CUSTOM/nvim

stow --restow --target="$NVIM_CUSTOM/nvim" -d "$DOTFILES_DIR" neovim
