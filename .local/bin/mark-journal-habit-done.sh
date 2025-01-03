#!/usr/bin/env bash

set -e -o pipefail

curl -s --location 'http://portainer.carosi.nl:7440/api/v1/habits/35da0e/completions' \
  --header "Authorization: Bearer $BEAVER_TOKEN" \
  --header "Content-Type: application/json" \
  --output /dev/null \
  --data "{\"date_fmt\": \"%d-%m-%Y\", \"date\": \"$(date +'%d-%m-%Y')\", \"done\": true}"
echo "Habit completion logged successfully."
