#!/usr/bin/env bash

# Install iterm shell integration
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash

# Install formulas and casks from Brewfile
./sync-brewfile.sh

# Create symlinks for all dotfiles
./create-symlinks.sh

# Install Java related software
./sdkman.sh

# Downloading kefctl binary
mkdir -p ~/.local/bin
wget https://raw.githubusercontent.com/kraih/kefctl/main/kefctl -P ~/.local/bin
chmod +x ~/.local/bin/kefctl

# Creating sleepwatcher launch agent
mkdir ~/Library/LaunchAgents
cp ../sleepwatcher/nl.carosi.sleepwatcher.plist ~/Library/LaunchAgents/nl.carosi.sleepwatcher.plist

# Creating symlinks for TimeOut applescripts
cp ../timeout/* ~/Library/Application\ Scripts/com.dejal.timeout

echo "Manually set homebrew's zsh as login shell"
echo "Manually copy ~/.localrc, ~/.m2/settings.xml, ~/.npmrc"
echo "Manually run macos-defaults.sh to apply MacOS defaults."
