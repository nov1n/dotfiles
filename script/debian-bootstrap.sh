#!/bin/env bash

apt update
apt install -y git stow zsh curl fzf thefuck zoxide
curl -sS https://starship.rs/install.sh | sh -s -- -y
git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote

git clone https://github.com/nov1n/dotfiles.git ~/dotfiles
cd ~/dotfiles/
stow -v .

chsh -s $(which zsh)
