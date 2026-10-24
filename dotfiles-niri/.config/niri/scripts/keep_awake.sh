#!/usr/bin/env bash

# ============================================================
# Script: Keep-Awake (Screen Inhibitor) Toggle
# Description: Prevents system idle lock and screen sleep by toggling swayidle
# Platform: Arch Linux x Niri x swayidle x hyprlock
# ============================================================

# Define paths and default configuration values
LOCK_FILE="/tmp/keep_awake.lock"
DEFAULT_MINUTES=5

# Display help message and usage instructions
show_help() {
  cat <<EOF
Usage: $(basename "$0") [MINUTES|-h|--help]

Description:
  Toggles Keep-Awake mode on/off. When enabled, stops swayidle
  service to prevent screen lock (hyprlock), dimming, and sleep.
  When disabled, restores swayidle service with the specified timeout.

Arguments:
  MINUTES       Idle timeout in minutes before locking (default: 5)
  -h, --help    Show this help message and exit

Examples:
  $(basename "$0")       Toggle keep-awake state using default 5 minutes
  $(basename "$0") 10    Toggle state and set idle timeout to 10 minutes
EOF
}

# Check if help flag is passed
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  show_help
  exit 0
fi

# Retrieve timeout from argument or fall back to the default value
TIMEOUT_MIN="${1:-$DEFAULT_MINUTES}"
TIMEOUT_SEC=$((TIMEOUT_MIN * 60))
SLEEP_TIMEOUT_SEC=$((TIMEOUT_SEC * 2))

# Check if keep-awake is currently active (lock file exists)
if [ -f "$LOCK_FILE" ]; then
  # Remove the lock file to restore normal state
  rm -f "$LOCK_FILE"

  # Restart swayidle with hyprlock and the defined timeouts
  if command -v swayidle >/dev/null 2>&1; then
    pkill -x "swayidle" 2>/dev/null || true
    swayidle -w \
      timeout "$TIMEOUT_SEC" 'hyprlock' \
      timeout "$SLEEP_TIMEOUT_SEC" 'niri msg action power-off-monitors' \
      before-sleep 'hyprlock' >/dev/null 2>&1 &
  fi
  systemctl --user start swayidle.service 2>/dev/null || true

  # Send notification indicating keep-awake is disabled
  notify-send -a "Power" -u normal -t 2000 \
    -h string:x-canonical-private-synchronous:keep-awake \
    -i preferences-desktop-screensaver \
    "Keep Awake" "Disabled (Auto-lock in ${TIMEOUT_MIN}m)"
  exit 0
fi

# Create lock file to activate keep-awake mode
touch "$LOCK_FILE"

# Terminate all active swayidle instances and systemd user services
pkill -x "swayidle" 2>/dev/null || true
systemctl --user stop swayidle.service 2>/dev/null || true

# Send notification indicating keep-awake is active
notify-send -a "Power" -u normal -t 2000 \
  -h string:x-canonical-private-synchronous:keep-awake \
  -i display-brightness \
  "Keep Awake" "Enabled (Screen will stay awake)"
