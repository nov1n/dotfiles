#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Desktop workspace
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️

osascript -e 'quit app "Aerospace"' || true
sleep 0.1
open -a Aerospace
while ! aerospace list-windows --all >/dev/null 2>&1; do
  sleep 0.001
done
aerospace layout v_accordion
sleep 0.1
aerospace trigger-binding --mode main alt-cmd-ctrl-b
sleep 0.1
aerospace move right
sleep 0.1
aerospace resize width +640
sleep 0.1
aerospace trigger-binding --mode main alt-cmd-ctrl-v
sleep 0.1
aerospace join-with right
sleep 0.1
aerospace trigger-binding --mode main alt-cmd-ctrl-t
sleep 0.1
aerospace join-with right
sleep 0.1
aerospace layout floating
sleep 0.1
aerospace layout tiling
sleep 0.1
aerospace layout v_accordion
sleep 0.1
aerospace focus up
sleep 0.1
