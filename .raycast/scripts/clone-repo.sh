#!/usr/bin/env bash

# Required arguments by Raycast:
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clone Git repository in ~/Projects
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 👨🏼‍💻
# @raycast.argument1 { "type": "text", "placeholder": "Current Tab URL", "percentEncoded": false, "optional": true }
# @raycast.argument2 { "type": "text", "placeholder": "<personal|picnic>", "percentEncoded": false, "optional": true }

REPO_URL="${1:-$(osascript "$HOME/.local/bin/get_url_from_focused_browser.scpt")}"
DOMAIN="${2:-personal}"
TARGET_DIR="$HOME/Projects/$DOMAIN"

# Extract the full repository path (e.g., "foo/bar") and the repository name (e.g., "bar")
REPO_PATH=$(echo "$REPO_URL" | sed -E 's|^https?://github\.com/([^/]+/[^/#]+).*|\1|')
REPO_NAME=$(basename "$REPO_PATH")
TARGET_PATH="$TARGET_DIR/$REPO_NAME"

if [ ! -d "$TARGET_PATH" ]; then
  git clone "git@github.com:${REPO_PATH}.git" "$TARGET_PATH"
fi

echo -e "nvim" | wezterm cli send-text --no-paste --pane-id "$(wezterm cli spawn --cwd "$TARGET_PATH")"
open -a Wezterm

echo "Opening '$TARGET_PATH'..."
