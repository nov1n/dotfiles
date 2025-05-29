#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Blinds
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🪟

zsh -ci 'hass-cli service call cover.close_cover --arguments entity_id=cover.office_blinds'
