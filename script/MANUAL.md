# Manual steps after bootstrap

bootstrap.sh already paused for `~/.ssh`, `~/.zsh_local.sh` and App Store
sign-in. Everything below is optional for bootstrapping and left to do by hand.

## Import app settings
- Raycast: sign in to restore Cloud Sync settings, if any. Then Settings → Extensions →
  Script Commands → Add Directory → `~/.raycast/scripts`.
- OrbStack: open the app once to finish setup (needed by `yt2jelly`).
- Atuin: `atuin login` (username, password and key from the backup), then `atuin sync`.

## Apps without a cask
- Audient iD: https://audient.com/products/audio-interfaces/ (driver + mixer app)

## Sign in / grant permissions
- Raycast, Karabiner-Elements, Hammerspoon, Homerow need
  Accessibility / Input Monitoring permissions in System Settings.
- Bitwarden, Proton VPN, Slack, Discord, Spotify.
- Licenses: CleanShot X, DaisyDisk, PixelSnap, Timemator, SuperDuper, MacWhisper, BoltAI, Homerow, Soulver, DevUtils, LaunchControl.
