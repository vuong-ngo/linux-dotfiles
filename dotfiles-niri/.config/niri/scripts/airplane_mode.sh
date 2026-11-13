#!/usr/bin/env bash

# ============================================================
# Script: Airplane Mode Toggle
# Description: Toggles Wi-Fi and Bluetooth without pkexec prompt
# ============================================================

show_help() {
  cat <<EOF
Usage: $(basename "$0") [OPTION]

Description:
  Toggles system radio transmissions (Wi-Fi & Bluetooth) between
  Airplane Mode (OFFLINE) and Normal Mode (ONLINE).

Options:
  -h, --help    Show this help message and exit
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  show_help
  exit 0
fi

# Check current state of Wi-Fi and rfkill
WIFI_STATE=$(nmcli radio wifi 2>/dev/null || echo "disabled")
RFKILL_BLOCKED=$(rfkill list wifi | grep -c "Soft blocked: yes")

if [[ "$WIFI_STATE" == "enabled" && "$RFKILL_BLOCKED" -eq 0 ]]; then
  # Enable Airplane Mode: Turn off NetworkManager radios and block rfkill
  nmcli radio all off
  rfkill block all 2>/dev/null || true

  notify-send -a "Network" -u normal -t 2000 \
    -h string:x-canonical-private-synchronous:airplane-mode \
    -i airplane-mode-symbolic \
    "Airplane Mode" "Enabled (All radios off)"
else
  # Disable Airplane Mode: Unblock rfkill and turn on NetworkManager radios
  rfkill unblock all 2>/dev/null || true
  sleep 0.2
  nmcli radio all on

  notify-send -a "Network" -u normal -t 2000 \
    -h string:x-canonical-private-synchronous:airplane-mode \
    -i network-wireless-signal-excellent-symbolic \
    "Airplane Mode" "Disabled (All radios on)"
fi