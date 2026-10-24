#!/usr/bin/env bash

# ============================================================
# Script: Airplane Mode Toggle
# Description: Toggles Wi-Fi and Bluetooth radio interfaces via nmcli and rfkill
# ============================================================

show_help() {
  cat <<EOF
Usage: $(basename "$0") [OPTION]

Description:
  Toggles system radio transmissions (Wi-Fi & Bluetooth) between
  Airplane Mode (OFFLINE) and Normal Mode (ONLINE).

Options:
  -h, --help    Show this help message and exit

Examples:
  $(basename "$0")       Toggle airplane mode on/off
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  show_help
  exit 0
fi

WIFI_STATE=$(nmcli radio wifi 2>/dev/null || echo "disabled")

if [ "$WIFI_STATE" = "enabled" ]; then
  nmcli radio all off
  pkexec rfkill block all &
  notify-send -a "Network" -u normal -t 2000 \
    -h string:x-canonical-private-synchronous:airplane-mode \
    -i airplane-mode-symbolic \
    "Airplane Mode" "Enabled (All radios off)"
else
  pkexec rfkill unblock all &
  nmcli radio all on
  sleep 1
  notify-send -a "Network" -u normal -t 2000 \
    -h string:x-canonical-private-synchronous:airplane-mode \
    -i network-wireless-signal-excellent-symbolic \
    "Airplane Mode" "Disabled (All radios on)"
fi
