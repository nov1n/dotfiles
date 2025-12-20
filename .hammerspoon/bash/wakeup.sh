#!/bin/zsh

. "$(dirname "$0")/helpers.sh"

echo "-- WAKE --"

current_hour=$(date +%H)
if [ "$current_hour" -ge 21 ]; then
  echo "It's after 9pm, skipping wake-up sequence..."
  exit 0
fi

if ! is_at_desk; then
  echo "Not at desk, skipping..."
  exit 0
fi

echo "Starting wake-up sequence..."
hass-cli service call automation.reload # Stops the 'Wake up' automation
hass-cli service call script.turn_off --arguments entity_id=script.new_script # Stops the 'Wake up light simulator'
hass-cli service call light.turn_on --arguments entity_id=light.monitor_led_strip
hass-cli service call light.turn_on --arguments entity_id=switch.desk_switch
hass-cli service call switch.turn_on --arguments entity_id=switch.desk_speakers
hass-cli service call input_boolean.turn_off --arguments entity_id=input_boolean.sleeping
hass-cli service call light.turn_off --arguments entity_id=light.night_lamp
hass-cli service call media_player.turn_off --arguments entity_id=media_player.marantz_cinema_70s
shortcuts run "Turn off Sleep Mode"
echo "Finished wake-up sequence."
