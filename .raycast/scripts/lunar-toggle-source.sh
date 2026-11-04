#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Lunar source
# @raycast.mode compact
#
# Optional parameters:
# @raycast.icon 🌓

LUNAR="/Applications/Lunar.app/Contents/MacOS/Lunar"

zsh -ci 'hass-cli service call switch.toggle --arguments entity_id=switch.kvm_fingerbot'
"$LUNAR" @ set input 144
