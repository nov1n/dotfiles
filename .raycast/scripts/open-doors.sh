#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open door
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🚪

zsh -ci 'hass-cli service call script.turn_on --arguments entity_id=script.open_main_door'
