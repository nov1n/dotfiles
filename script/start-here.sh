#!/usr/bin/env bash

# Download this file from Github and run it on a new machine to set everything up.

# Install brew
sudo xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
export PATH="/opt/homebrew/bin:$PATH"
brew install git

# Create ssh key for github
if [ -f ~/.ssh/id_ed25519 ]; then
  echo "Existing ssh key found, exiting."
  exit 0
fi

ssh-keygen -t ed25519 -C "robert@carosi.nl"
eval "$(ssh-agent -s)"
cat > ~/.ssh/config << EOM
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
EOM
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
echo "Press any key to continue when you added the key to Github..."

# -s: Do not echo input coming from a terminal
# -n 1: Read one character
read -s -n 1

# Clone public dotfile repo
git clone git@github.com:nov1n/dotfiles.git ~/.dotfiles
cd ~/.dotfiles/script
./bootstrap.sh