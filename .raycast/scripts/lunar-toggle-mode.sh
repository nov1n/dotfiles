#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Lunar mode
# @raycast.mode compact
#
# Optional parameters:
# @raycast.icon 🌕

LUNAR="/usr/local/bin/lunar"

current_mode=
new_mode=
current_mode=$(defaults read fyi.lunar.Lunar adaptiveBrightnessMode | sed 's/^"//;s/"$//' | tr '[:upper:]' '[:lower:]')

case "$current_mode" in
  "location")
    new_mode="manual"
    ;;
  "manual")
    new_mode="location"
    ;;
  *)
    echo "Current mode not in [manual, location], doing nothing"
    exit 1
    ;;
esac
echo "Setting mode to $new_mode"
"$LUNAR" mode $new_mode
