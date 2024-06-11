#!/bin/zsh
# https://www.kodiakskorner.com/log/258
# Use absolute paths to scripts.
. "$(dirname "$0")/helpers.sh"

echo "\n\n$(date): WAKE\n"

if ! connected_to_home_network; then
  echo "Exiting."
  exit 1
fi

echo "Turning on DAC and lights..."
retry hass-cli service call light.turn_on --arguments entity_id=light.desk_switch
retry hass-cli service call light.turn_on --arguments entity_id=light.monitor_led_strip

echo "Turning on KEF LSX..."
retry kefctl --input optical
