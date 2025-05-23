#!/bin/bash

. "$(dirname "$0")/helpers.sh"

echo "-- SLEEP --"

exit_if_not_at_desk

echo "Turning off DAC, speakers, and lights..."
#retry /opt/homebrew/bin/hass-cli service call switch.turn_off --arguments entity_id=switch.desk_speakers
#sleep 2
#retry /opt/homebrew/bin/hass-cli service call light.turn_off --arguments entity_id=light.desk_switch
#retry /opt/homebrew/bin/hass-cli service call light.turn_off --arguments entity_id=light.monitor_led_strip
