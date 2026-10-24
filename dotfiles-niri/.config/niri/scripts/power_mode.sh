#!/usr/bin/env bash

# ============================================================
# Script: Power Profile Strategy Switcher
# Description: Changes system CPU power profile via powerprofilesctl
# ============================================================

show_help() {
  cat <<EOF
Usage: $(basename "$0") <performance|balanced|power-saver> [OPTION]

Description:
  Applies system-wide CPU power profile and synchronizes notifications.

Modes:
  performance    Maximum CPU scaling and system responsiveness
  balanced       Default balanced power and speed
  power-saver    Maximum battery conservation (throttled CPU)

Options:
  -h, --help     Show this help message and exit

Examples:
  $(basename "$0") performance
  $(basename "$0") balanced
  $(basename "$0") power-saver
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" || -z "${1:-}" ]]; then
  show_help
  exit 0
fi

TARGET_MODE="$1"

if [[ "$TARGET_MODE" != "performance" && "$TARGET_MODE" != "balanced" && "$TARGET_MODE" != "power-saver" ]]; then
  echo "Error: Invalid mode '$TARGET_MODE'"
  show_help
  exit 1
fi

powerprofilesctl set "$TARGET_MODE" 2>/dev/null || true

notify-send -a "Power" -u normal -t 2000 \
  -h string:x-canonical-private-synchronous:power-profile \
  -i speedometer-symbolic \
  "Power Profile" "Switched to ${TARGET_MODE^}"
