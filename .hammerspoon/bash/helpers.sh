retry() {
  local red='\033[0;31m'
  local clear='\033[0m'
  local retries=5
  local count=0

  until timeout 5 "$@"; do
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

_is_on_home_network() {
  curl -s http://192.168.50.1 >/dev/null
}

is_at_desk() {
  display_info=$(system_profiler SPDisplaysDataType)
  internal_display_count=$(echo "$display_info" | grep -c "Built-in Liquid Retina XDR Display")
  total_display_count=$(echo "$display_info" | grep -c "Resolution:")
  if [[ "$total_display_count" -eq 1 && "$internal_display_count" -eq 1 ]]; then
    echo "Only internal display connected"
    return 1
  elif ! _is_on_home_network; then
    echo "Not on home network"
    return 1
  else
    echo "At my desk"
    return 0
  fi
}
