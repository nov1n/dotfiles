#!/usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Desktop workspace
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🖥️

DURATION=0.05

osascript -e 'quit app "Aerospace"' || true
sleep $DURATION
open -a Aerospace
while ! aerospace list-windows --all >/dev/null 2>&1; do
  sleep $DURATION
done
aerospace workspace main >/dev/null 2>&1
sleep $DURATION
aerospace layout v_accordion
sleep $DURATION
aerospace trigger-binding --mode main alt-cmd-ctrl-b
sleep $DURATION
aerospace move right
sleep $DURATION
aerospace resize width +640
sleep $DURATION
aerospace trigger-binding --mode main alt-cmd-ctrl-v
sleep $DURATION
aerospace join-with right
sleep $DURATION
aerospace trigger-binding --mode main alt-cmd-ctrl-t
sleep $DURATION
aerospace join-with right
sleep $DURATION
aerospace layout floating
sleep $DURATION
aerospace layout tiling
sleep $DURATION
aerospace layout v_accordion
sleep $DURATION
aerospace focus up
sleep $DURATION
