#!/usr/bin/env bash

# Install formulas and casks from Brewfile
./sync-brewfile.sh

# Create symlinks for all dotfiles
./create-symlinks.sh

# Install Java related software
./sdkman.sh

# Creating sleepwatcher launch agent
mkdir ~/Library/LaunchAgents
cp ../sleepwatcher/nl.carosi.sleepwatcher.plist ~/Library/LaunchAgents/nl.carosi.sleepwatcher.plist

# Creating symlinks for TimeOut applescripts
cp ../timeout/* ~/Library/Application\ Scripts/com.dejal.timeout

echo "Manually set homebrew's zsh as login shell"
echo "Manually copy ~/.zsh_local.sh, ~/.m2/settings.xml, ~/.npmrc"
echo "Manually run macos-defaults.sh to apply MacOS defaults."
