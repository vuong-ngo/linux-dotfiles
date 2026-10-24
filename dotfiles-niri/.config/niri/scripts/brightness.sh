#!/usr/bin/env bash

# ============================================================
# Script: Screen Brightness Control
# Description: Adjusts display brightness using brightnessctl with OSD notifications
# ============================================================

show_help() {
  cat <<EOF
Usage: $(basename "$0") <up|down|set VALUE> [OPTION]

Description:
  Adjusts display brightness level and dispatches an OSD notification.

Options:
  up            Increase brightness by 1%
  down          Decrease brightness by 1%
  set VALUE     Set brightness directly (e.g. set 80%)
  -h, --help    Show this help message and exit

Examples:
  $(basename "$0") up        # Increase brightness
  $(basename "$0") down      # Decrease brightness
  $(basename "$0") set 80%   # Set to 80%
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || -z "${1:-}" ]]; then
  show_help
  exit 0
fi

case "$1" in
up)
  brightnessctl -e4 -n2 set 1%+ >/dev/null 2>&1
  ;;
down)
  brightnessctl -e4 -n2 set 1%- >/dev/null 2>&1
  ;;
set)
  if [ -n "${2:-}" ]; then
    brightnessctl set "$2" >/dev/null 2>&1
  else
    echo "Error: Missing percentage/value for set"
    exit 1
  fi
  ;;
*)
  echo "Invalid command: $1"
  show_help
  exit 1
  ;;
esac

CURRENT=$(brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d '%')

notify-send -a "Display" -t 1200 \
  -h string:x-canonical-private-synchronous:display-brightness \
  -h int:value:"$CURRENT" \
  -i display-brightness-symbolic \
  "Brightness" "${CURRENT}%"
