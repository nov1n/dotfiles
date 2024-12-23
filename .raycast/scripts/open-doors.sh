#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open doors
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🚪

zsh -ci 'hass-cli service call automation.trigger --arguments entity_id=automation.open_doors'
