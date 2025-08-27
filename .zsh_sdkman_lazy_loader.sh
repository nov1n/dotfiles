# lightweight lazy SDKMAN loader

# SDKMAN root
SDKMAN_DIR="$HOME/.sdkman"

# One-time SDKMAN init + stub cleanup
_sdkman_lazy_load() {
  # Remove all generated stubs (candidate executables only)
  for bin in "$SDKMAN_DIR"/candidates/*/current/bin/*; do
    cmd=$(basename "$bin")
    [[ -x "$bin" ]] || continue
    [[ "$cmd" == *.* ]] && continue
    if [[ "$(whence -w "$cmd")" == "$cmd: function" ]]; then
      unset -f "$cmd"
    fi
  done
  # Remove the hardcoded `sdk` stub if still present
  [[ "$(whence -w sdk)" == "sdk: function" ]] && unset -f sdk

  # Info message (printed once per shell session)
  echo "[lazy-sdkman] Loading SDKMAN environment..."

  # Source official SDKMAN init
  source "$SDKMAN_DIR/bin/sdkman-init.sh"

  # Re-run the originally requested command
  "$@"
}

# Hardcoded stub for the `sdk` command itself
sdk() {
  _sdkman_lazy_load sdk "$@"
}

# Auto-generate stubs for candidate executables
for bin in "$SDKMAN_DIR"/candidates/*/current/bin/*; do
  cmd=$(basename "$bin")

  [[ -x "$bin" ]] || continue
  [[ "$cmd" == *.* ]] && continue

  # Don’t override existing aliases or functions
  if alias "$cmd" &>/dev/null || [[ "$(whence -w "$cmd")" == "$cmd: function" ]]; then
    continue
  fi

  eval "
    $cmd() {
      _sdkman_lazy_load $cmd \"\$@\"
    }
  "
done
