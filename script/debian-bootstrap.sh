#!/bin/env bash

apt update
apt install -y git stow zsh
git clone https://github.com/nov1n/dotfiles.git ~/dotfiles
cd ~/dotfiles/
stow

# Set default shell
