#!/usr/bin/env bash

# ============================================================
# Script: show_pin.sh (Battery & Power Status)
# Description: Displays current battery percentage, status, and health info
# ============================================================

set -euo pipefail

BAT_PATH=$(find /sys/class/power_supply/ -name "BAT*" 2>/dev/null | head -n 1)

if [ -n "$BAT_PATH" ] && [ -f "$BAT_PATH/capacity" ]; then
  CAP=$(cat "$BAT_PATH/capacity")
  STATUS=$(cat "$BAT_PATH/status" 2>/dev/null || echo "Unknown")
else
  CAP="100"
  STATUS="AC / Desktop"
fi

ICON="battery"
if [ "$STATUS" = "Charging" ]; then
  ICON="battery-charging"
elif [ "$CAP" -le 20 ]; then
  ICON="battery-caution"
fi

MSG="󰁹 Battery: ${CAP}% (${STATUS})"

if [ -t 1 ]; then
  echo "$MSG"
else
  notify-send -a "Battery" -u normal -t 2000 \
    -i "$ICON" \
    -h string:x-canonical-private-synchronous:battery \
    "Power Status" "$MSG"
fi
