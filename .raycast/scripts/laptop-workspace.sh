#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Laptop workspace
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 💻

osascript -e 'quit app "Aerospace"' || true
open -a Aerospace
