#!/bin/env bash

apt update
apt install -y git stow zsh curl thefuck zoxide lsd bat man
curl -sS https://starship.rs/install.sh | sh -s -- -y
git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &&
	~/.fzf/install --key-bindings --completion --no-update-rc &&
	ln -s ~/.fzf/bin/fzf /usr/local/bin/

git clone https://github.com/nov1n/dotfiles.git ~/dotfiles
cd ~/dotfiles/
stow -v .

chsh -s $(which zsh)
zsh
