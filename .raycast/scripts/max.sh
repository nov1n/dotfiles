#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Max
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 💯

zsh -ci 'hass-cli service call button.press --arguments entity_id=button.standing_desk_preset_4'
