#!/bin/bash

. "$(dirname "$0")/helpers.sh"

echo "-- WAKE --"

exit_if_not_at_desk

echo "Turning on DAC, speakers, and lights..."
retry hass-cli service call light.turn_on --arguments entity_id=light.desk_switch
retry hass-cli service call light.turn_on --arguments entity_id=light.monitor_led_strip
retry hass-cli service call switch.turn_on --arguments entity_id=switch.desk_speakers

echo "Turning off kitchen..."
retry hass-cli service call homeassistant.turn_off --arguments area_id=kitchen
