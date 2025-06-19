#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Desktop workspace
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️

DURATION=0.1

osascript -e 'quit app "Aerospace"' || true
sleep $DURATION
open -a Aerospace
while ! aerospace list-windows --all >/dev/null 2>&1; do
  sleep $DURATION
done

aerospace flatten-workspace-tree
sleep $DURATION
aerospace layout v_accordion
sleep $DURATION
aerospace trigger-binding --mode main alt-cmd-ctrl-g
sleep $DURATION
aerospace move right
sleep $DURATION
aerospace trigger-binding --mode main alt-cmd-ctrl-t
sleep $DURATION
aerospace join-with right
sleep $DURATION
aerospace trigger-binding --mode main alt-cmd-ctrl-f
sleep $DURATION
aerospace join-with right
sleep $DURATION
aerospace layout floating
sleep $DURATION
aerospace layout tiling
sleep $DURATION
aerospace layout v_accordion
sleep $DURATION
aerospace resize width +640
