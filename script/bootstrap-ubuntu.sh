#!/usr/bin/env bash

install_linuxbrew_packages() {
  echo "Installing linuxbrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo "Installing linuxbrew packages..."
  cat <<'EOF' >Brewfile
tap "timescam/tap"
tap "wezterm/wezterm-linuxbrew"
brew "bat"
brew "fd"
brew "fzf"
brew "git-delta"
brew "lazygit"
brew "lsd"
brew "neovim"
brew "python@3.13"
brew "node"
brew "ripgrep"
brew "rust"
brew "starship"
brew "yarn"
brew "zoxide"
brew "zsh"
brew "timescam/tap/pay-respects"
brew "wezterm/wezterm-linuxbrew/wezterm"
EOF
  brew bundle install
}

install_apt_packages() {
  echo "Updating package lists..."
  sudo apt update || {
    echo "Failed to update package lists" exit 1
  }
  echo "Installing apt packages..."
  sudo apt install -y --allow-unauthenticated ca-certificates git stow curl man sudo wget unzip cmake ninja-build gettext imagemagick || {
    echo "Failed to install packages"
    exit 1
  }
  echo "Installint pay-respects..."
  curl -sSfL https://raw.githubusercontent.com/iffse/pay-respects/main/install.sh | sh
}

generate_ssh_key() {
  ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N "" -C "robert@carosi.nl"
  eval "$(ssh-agent -s)"
  touch ~/.ssh/config
  printf "Host github.com\n  AddKeysToAgent yes\n  IdentityFile ~/.ssh/id_ed25519\n" >>~/.ssh/config
  printf "Add this public key to Github:\n"
  cat ~/.ssh/id_ed25519.pub
  echo "Press any key when done..."
  read -n 1 -s -r
}

install_dotfiles() {
  echo "Cloning dotfiles repository..."
  git clone https://github.com/nov1n/dotfiles.git ~/dotfiles || {
    echo "Failed to clone dotfiles repository"
    exit 1
  }
  cd ~/dotfiles/ || exit
  echo "Symlinking dotfiles..."
  stow -v . || {
    echo "Failed to symlink dotfiles"
    exit 1
  }
}

install_linuxbrew_packages
install_apt_packages
generate_ssh_key
install_dotfiles

# Change the default shell to zsh
echo "Changing the default shell to zsh..."
command -v zsh | sudo tee -a /etc/shells
sudo chsh -s "$(which zsh)" "$USER" || {
  echo "Failed to change shell"
  exit 1
}

echo "Script completed successfully. Run 'zsh' to start..."
