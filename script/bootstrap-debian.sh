#!/bin/env bash

sudo apt update
sudo apt install -y git stow zsh curl thefuck zoxide lsd bat man tmux sudo wget unzip cmake ninja-build gettext
curl -sS https://starship.rs/install.sh | sh -s -- -y
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &&
	~/.fzf/install --key-bindings --completion --no-update-rc &&
	chmod +x ~/.fzf/bin/fzf &&
	ln -s ~/.fzf/bin/fzf /usr/local/bin/

# Build and install neovim from source
git clone https://github.com/neovim/neovim
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build
cpack -G DEB
sudo dpkg -i nvim-linux64.deb

git clone https://github.com/nov1n/dotfiles.git ~/dotfiles
cd ~/dotfiles/
stow -v .

chsh -s $(which zsh)
zsh
