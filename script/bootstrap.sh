#!/usr/bin/env bash
# Bootstrap a fresh Mac. Idempotent: safe to re-run.
#
#   xcode-select --install
#   git clone https://github.com/nov1n/dotfiles ~/dotfiles
#   ~/dotfiles/script/bootstrap.sh
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
SCRIPT_DIR="$DOTFILES/script"

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

install_homebrew() {
  log "Homebrew"
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_packages() {
  log "Brewfile (formulae, casks, App Store apps)"
  if ! mas account >/dev/null 2>&1; then
    echo "Not signed in to the App Store: mas apps will fail. Sign in and re-run."
  fi
  brew bundle --file="$SCRIPT_DIR/Brewfile"
}

link_dotfiles() {
  log "Symlinking dotfiles with stow"
  cd "$DOTFILES"
  stow -R -v .
}

init_submodules() {
  log "Submodules (need your SSH key for GitHub)"
  git -C "$DOTFILES" submodule update --init --recursive \
    || echo "Submodules failed: restore ~/.ssh and run 'git submodule update --init'"
}

install_shell_plugins() {
  log "antidote (zsh plugin manager)"
  [ -d "$HOME/.antidote" ] \
    || git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
}

install_toolchains() {
  log "Neovim (via bob) and Node (via fnm)"
  command -v bob >/dev/null && bob install stable && bob use stable || true
  command -v fnm >/dev/null && fnm install --lts || true
}

set_login_shell() {
  log "Login shell -> Homebrew zsh"
  local zsh_path=/opt/homebrew/bin/zsh
  grep -qx "$zsh_path" /etc/shells || echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  [ "$SHELL" = "$zsh_path" ] || chsh -s "$zsh_path"
}

apply_macos_defaults() {
  log "macOS defaults"
  "$SCRIPT_DIR/macos-defaults.sh"
}

main() {
  install_homebrew
  install_packages
  link_dotfiles
  init_submodules
  install_shell_plugins
  install_toolchains
  set_login_shell
  apply_macos_defaults
  log "Done. Remaining manual steps: $SCRIPT_DIR/MANUAL.md"
}

main "$@"
