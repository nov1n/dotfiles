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
  curl -s http://raspberrypi.local > /dev/null
}
