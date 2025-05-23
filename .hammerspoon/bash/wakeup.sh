#!/bin/zsh

. "$(dirname "$0")/helpers.sh"

echo "-- WAKE --"

if ! is_at_desk; then
  echo "Not at desk, skipping..."
  exit 0
fi

echo "Turning on DAC, speakers, and lights..."
hass-cli service call light.turn_on --arguments entity_id=light.monitor_led_strip
hass-cli service call light.turn_on --arguments entity_id=light.desk_switch
hass-cli service call switch.turn_on --arguments entity_id=switch.desk_speakers
hass-cli service call input_boolean.turn_off --arguments entity_id=input_boolean.sleeping
