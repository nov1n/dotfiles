#!/usr/bin/env bash
# Trimmed macOS defaults: only settings carried over from the old script that I
# actually care about. Re-run safe.

osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

# Text input: no auto-correct annoyances
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Keyboard: fast repeat, no press-and-hold accents, Globe key does nothing
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 30
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write com.apple.HIToolbox AppleFnUsageType -int 0

# Trackpad: silent clicking, no natural scrolling (needs logout)
defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Accessibility: reduce motion (com.apple.universalaccess may need Full Disk
# Access for the terminal; don't fail the whole script over it)
defaults write com.apple.universalaccess reduceMotion -bool true 2>/dev/null \
  || echo "Couldn't set Reduce motion; enable it in System Settings > Accessibility > Display."
defaults write com.apple.Accessibility ReduceMotionEnabled -int 1

# Locale
defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# General UI
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Security: require password immediately after screensaver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder FXRemoveOldTrashItems -bool true
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
chflags nohidden ~/Library

# Dock
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock minimize-to-application -bool true
# Hot corners: all off (1 = no action)
for corner in tl tr bl br; do
  defaults write com.apple.dock "wvous-$corner-corner" -int 1
  defaults write com.apple.dock "wvous-$corner-modifier" -int 0
done

# Shortcut: Cmd+Ctrl+Alt+N (hyper+N) opens Notification Center (hotkey 163;
# parameters are ASCII 'n', keycode 45, modifier mask)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 163 \
  '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>110</integer><integer>45</integer><integer>1835008</integer></array><key>type</key><string>standard</string></dict></dict>'
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true

# Dock: pinned apps, in groups separated by spacers ("-" small, "--" full-size)
dock_items=(
  "/Applications/BoltAI.app"
  "/Applications/MacWhisper.app"
  -
  "/Applications/Spotify.app"
  "/Applications/WhatsApp.app"
  -
  "/Applications/Ghostty.app"
  "/Applications/Firefox.app"
  -
  "/System/Applications/Calendar.app"
  "/Applications/Proton Mail.app"
  "/System/Applications/Reminders.app"
  -
  "/Applications/BambuStudio.app"
  --
  "/Applications/OrbStack.app"
)
if command -v dockutil >/dev/null; then
  dockutil --remove all --no-restart >/dev/null
  for item in "${dock_items[@]}"; do
    case "$item" in
      -) dockutil --add '' --type small-spacer --section apps --no-restart >/dev/null ;;
      --) dockutil --add '' --type spacer --section apps --no-restart >/dev/null ;;
      *)
        if [ -d "$item" ]; then
          dockutil --add "$item" --no-restart >/dev/null
        else
          echo "Dock: skipping missing $item"
        fi
        ;;
    esac
  done
  dockutil --add "$HOME/Downloads" --view fan --display stack --sort dateadded \
    --section others --no-restart >/dev/null
else
  echo "dockutil not found; skipping pinned Dock items."
fi

for app in Finder Dock SystemUIServer; do killall "$app" >/dev/null 2>&1 || true; done
echo "macOS defaults applied. Some changes need a logout/restart."
