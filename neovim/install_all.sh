#!/usr/bin/env bash
NVIM_DIR=~/.config/nvb
export NVIM_DIR

rm -rf $NVIM_DIR

mkdir -p $NVIM_DIR

stow --restow --target="$NVIM_DIR" -d "$DOTFILES_DIR" neovim
