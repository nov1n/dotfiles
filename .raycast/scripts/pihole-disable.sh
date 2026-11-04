#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Pihole
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🍰

zsh -ci 'curl "http://192.168.50.3:8046/admin/api.php?disable=300&auth=$PIHOLE_TOKEN"'
