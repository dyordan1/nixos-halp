#! /usr/bin/env bash

set -o nounset -o errexit -o pipefail

MARKER_FILE="/tmp/ssh-inactivity-flag"

STATUS=$(netstat | grep ssh | grep ESTABLISHED &>/dev/null && echo active || echo inactive)

if [ "$STATUS" == "inactive" ]; then
  if [ -f "$MARKER_FILE" ]; then
    echo "Powering off due to ssh inactivity."
    rm --force "$MARKER_FILE"
    poweroff
  else
    # Create a marker file so that it will shut down if still inactive on the next time this script runs.
    touch "$MARKER_FILE"
  fi
else
  # Delete marker file if it exists
  rm --force "$MARKER_FILE"
fi