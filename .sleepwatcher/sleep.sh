#!/bin/bash

. "$(dirname "$0")/helpers.sh"

echo "[$(date)] -- SLEEP --"

exit_if_not_at_desk

echo "Turning off DAC and lights..."
retry hass-cli service call light.turn_off --arguments entity_id=light.desk_switch
retry hass-cli service call light.turn_off --arguments entity_id=light.monitor_led_strip

echo "Turning off KEF LSX..."
if retry kefctl --status | grep -q "Optical"; then
  retry kefctl --off
fi
