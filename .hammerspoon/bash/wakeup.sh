#!/bin/bash

. "$(dirname "$0")/helpers.sh"

echo "-- WAKE --"

if ! is_at_desk; then
  echo "Not at desk, skipping..."
  exit 0
fi

echo "Turning on DAC, speakers, and lights..."
retry /opt/homebrew/bin/hass-cli service call light.turn_on --arguments entity_id=light.monitor_led_strip
retry /opt/homebrew/bin/hass-cli service call light.turn_on --arguments entity_id=light.desk_switch
retry /opt/homebrew/bin/hass-cli service call switch.turn_on --arguments entity_id=switch.desk_speakers
retry /opt/homebrew/bin/hass-cli service call input_boolean.turn_off --arguments entity_id=input_boolean.sleeping
