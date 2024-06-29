#!/bin/env bash

apt update
apt install -y git stow zsh curl thefuck zoxide lsd bat man locales tmux sudo wget unzip
curl -sS https://starship.rs/install.sh | sh -s -- -y
git clone --depth=1 https://github.com/mattmc3/antidote.git ~/.antidote
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &&
	~/.fzf/install --key-bindings --completion --no-update-rc &&
	ln -s ~/.fzf/bin/fzf /usr/local/bin/

sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
locale-gen

wget https://github.com/MordechaiHadad/bob/releases/download/v3.0.1/bob-linux-aarch64.zip
unzip -j bob-linux-aarch64.zip bob-linux-aarch64/bob -d ~/.bob
cd ~/.bob
chmod +x bob
echo "export PATH=\"${HOME}/.local/share/bob/nvim-bin:\$PATH\"" >>~/.zshrc
source ~/.bashrc
./bob install stable
./bob use stable

git clone https://github.com/nov1n/dotfiles.git ~/dotfiles
cd ~/dotfiles/
stow -v .

chsh -s $(which zsh)
zsh
