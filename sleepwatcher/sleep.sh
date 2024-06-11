#!/bin/zsh
# https://www.kodiakskorner.com/log/258
# Use absolute paths to scripts.
. "$(dirname "$0")/helpers.sh"

echo "\n\n$(date): SLEEP\n"

if ! connected_to_home_network; then
  echo "Exiting."
  exit 1
fi

echo "Turning off DAC and lights..."
retry hass-cli service call light.turn_off --arguments entity_id=light.desk_switch
retry hass-cli service call light.turn_off --arguments entity_id=light.monitor_led_strip

echo "Turning off KEF LSX..."
if retry kefctl --status | grep -q "Optical"; then
  retry kefctl --off
fi
