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
warn() { printf '\033[1;33m%s\033[0m\n' "$*"; }
die() { printf '\033[1;31m%s\033[0m\n' "$*" >&2; exit 1; }

# Print instructions and block until the user presses Enter (or aborts).
wait_for_user() {
  [ -t 0 ] || die "This step needs manual action; re-run bootstrap.sh in an interactive terminal."
  printf '%s\n' "$@"
  read -r -p "Press Enter when done (Ctrl-C to abort)... " _
}

# Secrets that can't live in the repo. Must be restored from a backup by hand
# before anything else runs: .gitconfig rewrites https://github.com/ to SSH and
# signs commits with the SSH key, so almost every git step depends on it.
SSH_KEY="$HOME/.ssh/id_ed25519"
LOCAL_SECRETS="$HOME/.zsh_local.sh"

restore_ssh_key() {
  log "SSH key for GitHub"
  until [ -f "$SSH_KEY" ] && [ -f "$SSH_KEY.pub" ]; do
    wait_for_user \
      "Missing $SSH_KEY (and/or .pub). Copy your ~/.ssh files from the backup, e.g.:" \
      "  cp -R /Volumes/<backup>/.ssh/. ~/.ssh/"
  done

  chmod 700 "$HOME/.ssh"
  find "$HOME/.ssh" -maxdepth 1 -type f ! -name '*.pub' ! -name known_hosts ! -name config \
    -exec chmod 600 {} +
  find "$HOME/.ssh" -maxdepth 1 -type f -name '*.pub' -exec chmod 644 {} +

  if ! ssh-keygen -F github.com >/dev/null 2>&1; then
    ssh-keyscan -t ed25519 github.com >>"$HOME/.ssh/known_hosts" 2>/dev/null
  fi

  # Store the passphrase in the Keychain so later git steps don't prompt.
  ssh-add --apple-use-keychain "$SSH_KEY" 2>/dev/null || true

  until github_ssh_ok; do
    wait_for_user \
      "GitHub rejected $SSH_KEY. Make sure it's the right key and added at" \
      "https://github.com/settings/keys, then try again."
  done
  echo "GitHub SSH access OK."
}

# `ssh -T` exits 1 even on success, so check the greeting instead. Capture the
# output first: piping ssh straight into grep fails under `set -o pipefail`.
github_ssh_ok() {
  local out
  out="$(ssh -T git@github.com 2>&1 || true)"
  grep -q "successfully authenticated" <<<"$out"
}

restore_local_secrets() {
  log "Local secrets ($LOCAL_SECRETS)"
  until [ -f "$LOCAL_SECRETS" ]; do
    wait_for_user \
      "Missing $LOCAL_SECRETS (machine-local env vars/tokens, sourced by .zshenv)." \
      "Copy it from the backup, e.g.:" \
      "  cp /Volumes/<backup>/.zsh_local.sh ~/"
  done
  chmod 600 "$LOCAL_SECRETS"
  echo "Found $LOCAL_SECRETS."
}

# True if every `mas` app in the Brewfile is already installed.
mas_apps_installed() {
  command -v mas >/dev/null || return 1
  local installed id
  installed="$(mas list 2>/dev/null | awk '{print $1}')"
  while read -r id; do
    grep -qx "$id" <<<"$installed" || return 1
  done < <(grep -Eo '^mas .*id: *[0-9]+' "$SCRIPT_DIR/Brewfile" | grep -Eo '[0-9]+$')
}

sign_in_app_store() {
  log "App Store sign-in"
  if mas_apps_installed; then
    echo "All App Store apps already installed."
    return
  fi
  # mas can no longer detect the signed-in account, so ask instead.
  open -a "App Store"
  wait_for_user "Sign in to the App Store (needed to install the mas apps in the Brewfile)."
}

install_homebrew() {
  log "Homebrew"
  if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_packages() {
  log "Brewfile (formulae, casks, App Store apps)"
  # Homebrew refuses to load formulae from third-party taps until trusted.
  local tap
  while read -r tap; do
    brew tap "$tap"
    brew trust --quiet --tap "$tap"
  done < <(sed -nE 's/^tap "([^"]+)".*/\1/p' "$SCRIPT_DIR/Brewfile")
  brew bundle --file="$SCRIPT_DIR/Brewfile"
}

link_dotfiles() {
  log "Symlinking dotfiles with stow"
  cd "$DOTFILES"
  stow -R -v .
}

init_submodules() {
  log "Submodules"
  # Only Hammerspoon spoons live in submodules, so don't abort the bootstrap.
  # The usual failure is a pinned commit that was never pushed upstream.
  git -C "$DOTFILES" submodule update --init --recursive \
    || warn "Submodule update failed; Hammerspoon spoons may be missing." \
      "Check that each pinned commit is pushed: git -C $DOTFILES submodule status"
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
  restore_ssh_key
  restore_local_secrets
  sign_in_app_store
  install_homebrew
  install_packages
  link_dotfiles
  init_submodules
  install_shell_plugins
  install_toolchains
  set_login_shell
  apply_macos_defaults
  print_manual_steps
}

print_manual_steps() {
  log "Bootstrap done. These steps still need manual intervention ($SCRIPT_DIR/MANUAL.md):"
  echo
  cat "$SCRIPT_DIR/MANUAL.md"
}

main "$@"
