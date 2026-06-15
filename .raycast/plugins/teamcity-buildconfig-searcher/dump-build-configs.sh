#!/bin/bash

set -e

OUTPUT_FILE="teamcity-build-configs.json"

echo "Fetching ALL build configurations from TeamCity API..."

if [ -z "$TEAMCITY_TOKEN" ]; then
  echo "Error: TEAMCITY_TOKEN environment variable is not set"
  exit 1
fi

TEAMCITY_URL="${TEAMCITY_URL:-https://teampicnic.teamcity.com}"

curl -s -H "Authorization: Bearer $TEAMCITY_TOKEN" \
  -H "Accept: application/json" \
  "${TEAMCITY_URL}/app/rest/buildTypes" >"$OUTPUT_FILE"

echo "All build configurations dumped to: $OUTPUT_FILE"
echo ""
echo "Summary:"
BUILD_COUNT=$(grep -o '"id"' "$OUTPUT_FILE" | wc -l)
echo "Total build configurations: $BUILD_COUNT"
