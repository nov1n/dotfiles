#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title 3D printer
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🖨️
# @raycast.needsConfirmation true

zsh -ci 'hass-cli service call switch.toggle --arguments entity_id=switch.3d_printer_switch'
