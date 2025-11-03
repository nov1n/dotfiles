#!/bin/bash

set -e

OUTPUT_FILE="teamcity-build-configs.json"

echo "Fetching ALL build configurations from TeamCity API..."

if [ -z "$TC_PAT" ]; then
  echo "Error: TC_PAT environment variable is not set"
  exit 1
fi

TEAMCITY_URL="${TEAMCITY_URL:-https://teampicnic.teamcity.com}"

curl -s -H "Authorization: Bearer $TC_PAT" \
  -H "Accept: application/json" \
  "${TEAMCITY_URL}/app/rest/buildTypes" > "$OUTPUT_FILE"

echo "All build configurations dumped to: $OUTPUT_FILE"
echo ""
echo "Summary:"
BUILD_COUNT=$(cat "$OUTPUT_FILE" | grep -o '"id"' | wc -l)
echo "Total build configurations: $BUILD_COUNT"
