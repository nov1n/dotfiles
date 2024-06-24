export HOME="/Users/carosi"
export PATH="/usr/sbin:/opt/homebrew/bin:/opt/homebrew/bin:${HOME}/.local/bin:$PATH"
. ~/.localrc

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

  # Check if there's any external display connected
  internal_display_count=$(echo "$display_info" | grep -c "Built-in Liquid Retina XDR Display")
  total_display_count=$(echo "$display_info" | grep -c "Resolution:")

  # Check if internal display is the only display and if connected to home network
  if [ "$total_display_count" -eq 1 ] && [ "$internal_display_count" -eq 1 ] || ! connected_to_home_network; then
    echo "Only internal display connected or not connected to home network. Exiting."
    exit 1
  fi
}
