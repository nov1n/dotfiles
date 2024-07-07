#!/usr/bin/env bash

install_starship() {
  local binary_url="https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz"
  local archive_path="starship.tar.gz"
  echo "Downloading Starship..."
  curl -Lo "$archive_path" "$binary_url" || {
    echo "Failed to download Starship"
    exit 1
  }
  echo "Extracting Starship..."
  tar -xzf "$archive_path" || {
    echo "Failed to extract Starship"
    exit 1
  }
  echo "Installing Starship..."
  sudo mv starship /usr/local/bin/ || {
    echo "Failed to move Starship"
    exit 1
  }
  rm -f "$archive_path"
}

install_packages() {
  echo "Updating package lists..."
  sudo apt update || {
    echo "Failed to update package lists" exit 1
  }
  echo "Installing packages..."
  sudo apt install -y git stow zsh curl thefuck zoxide lsd man sudo wget unzip cmake ninja-build gettext || {
    echo "Failed to install packages"
    exit 1
  }
}

install_bat() {
  local bat_url="https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-musl_0.24.0_amd64.deb"
  local bat_deb="bat-musl_0.24.0_amd64.deb"
  echo "Downloading bat..."
  wget "$bat_url" || {
    echo "Failed to download bat"
    exit 1
  }
  echo "Installing bat..."
  sudo dpkg -i "$bat_deb" || {
    echo "Failed to install bat"
    exit 1
  }
  rm "$bat_deb"
}

install_fzf() {
  echo "Cloning fzf repository..."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf || {
    echo "Failed to clone fzf repository"
    exit 1
  }
  echo "Installing fzf..."
  ~/.fzf/install --key-bindings --completion --no-update-rc || {
    echo "Failed to install fzf"
    exit 1
  }
  chmod +x ~/.fzf/bin/fzf
  sudo ln -s ~/.fzf/bin/fzf /usr/local/bin/ || {
    echo "Failed to link fzf"
    exit 1
  }
}

install_neovim() {
  echo "Cloning Neovim repository..."
  git clone https://github.com/neovim/neovim || {
    echo "Failed to clone Neovim repository"
    exit 1
  }
  cd neovim || exit
  echo "Building Neovim..."
  make CMAKE_BUILD_TYPE=RelWithDebInfo || {
    echo "Failed to build Neovim"
    exit 1
  }
  cd build || exit
  echo "Packaging Neovim..."
  cpack -G DEB || {
    echo "Failed to package Neovim"
    exit 1
  }
  echo "Installing Neovim..."
  sudo dpkg -i nvim-linux64.deb || {
    echo "Failed to install Neovim"
    exit 1
  }
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

install_rust() {
  echo "Downloading and installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

install_packages
install_starship
install_bat
install_fzf
install_neovim
install_dotfiles
install_rust

# Change the default shell to zsh
echo "Changing the default shell to zsh..."
sudo chsh -s "$(which zsh)" "$USER" || {
  echo "Failed to change shell"
  exit 1
}

# Set a trap to start zsh in the parent shell
trap 'exec zsh' EXIT

echo "Script completed successfully. Starting zsh..."
