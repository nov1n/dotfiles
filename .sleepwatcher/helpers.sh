retry() {
  local red='\033[0;31m'
  local clear='\033[0m'
  local retries=5
  local count=0

  until timeout 5 $@; do
    exit=$?
    wait=2
    count=$(($count + 1))
    if [ $count -lt $retries ]; then
      echo "Retry $count/$retries exited $exit, retrying in $wait seconds..." >&2
      sleep $wait
    else
      echo "${red}Retry $count/$retries exited $exit, no more retries left.${clear}" >&2
      return $exit
    fi
  done
  return 0
}

connected_to_home_network() {
  echo 'Checking if connected to home network...'
  curl -s http://portainer.carosi.nl > /dev/null
}

exit_if_not_at_desk() {
  # Get the display information
  display_info=$(system_profiler SPDisplaysDataType)

  # Check if there's any display with a name other than "Built-In Retina Display"
  external_display_connected=$(echo "$display_info" | grep "Resolution:" | grep -q -v "Built-in Liquid Retina XDR Display"; echo $?)

  # Exit if no external display connected or not on home network --> we are not at our desk.
  if [ "$external_display_connected" -eq 0 ] || ! connected_to_home_network; then
    echo "No external display connected or not connected to home network. Exiting."
    exit 1
  fi
}
