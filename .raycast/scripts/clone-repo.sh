#!/usr/bin/env bash

# Required arguments by Raycast:
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clone Git repository in ~/Projects directory
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 👨🏼‍💻
# @raycast.argument1 { "type": "text", "placeholder": "Current Tab URL", "percentEncoded": false, "optional": true }
# @raycast.argument2 { "type": "text", "placeholder": "<personal|picnic>", "percentEncoded": false, "optional": true }

REPO_URL="${1:-$(osascript "$HOME/.local/bin/get_url_from_focused_browser.scpt")}"
DOMAIN="${2:-personal}"
TARGET_DIR="${2:-"$HOME/Projects/$DOMAIN"}"

REPO_PATH=$(echo "$REPO_URL" | sed -E 's|^https?://github\.com/([^/]+)/([^/#]+).*|\1/\2|')
TARGET_PATH="$TARGET_DIR/${REPO_PATH}"
if [ ! -d "$TARGET_PATH" ]; then
  git clone "git@github.com:${REPO_PATH}.git" "$TARGET_PATH"
fi

echo -e "nvim" | wezterm cli send-text --no-paste --pane-id "$(wezterm cli spawn --cwd "$TARGET_PATH")"
open -a Wezterm

echo "Opening '$TARGET_PATH'..."
