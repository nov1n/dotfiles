#!/usr/bin/env bash

for file in $(find ../dotfiles -type f -mindepth 1 -maxdepth 1); do
	src=$(readlink -f $file)
	dst=$HOME/$(basename $file)
	echo "Linking $src to $dst"
	ln -fs $src $dst 
done

ln -fs $(readlink -f ../dotfiles/.config/nvim) $HOME/.config
ln -fs $(readlink -f ../dotfiles/.git_hooks) $HOME
mkdir -p ~/.local
ln -fs $(readlink -f ../dotfiles/.local/bin) $HOME/.local/

ln -fs $HOME/.dotfiles/dotfiles/.vimrc $HOME/.ideavimrc
