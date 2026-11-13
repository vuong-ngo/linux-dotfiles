#!/usr/bin/env bash

# ============================================================
# Script: Keep-Awake (Screen Inhibitor) Toggle
# Description: Prevents system idle lock and screen sleep by toggling swayidle
# Platform: Arch Linux x Niri x swayidle x hyprlock
# ============================================================

LOCK_FILE="/tmp/keep_awake.lock"
DEFAULT_MINUTES=5

start_swayidle() {
  local timeout_sec=$(( $1 * 60 ))
  local sleep_timeout_sec=$(( timeout_sec * 2 ))

  pkill -x "swayidle" 2>/dev/null || true
  if command -v swayidle >/dev/null 2>&1; then
    nohup swayidle -w \
      timeout "$timeout_sec" 'hyprlock' \
      timeout "$sleep_timeout_sec" 'niri msg action power-off-monitors' \
      resume 'niri msg action power-on-monitors' \
      before-sleep 'hyprlock' >/dev/null 2>&1 &
    disown
  fi
}

# Mode: Startup with Niri: Always remove old lock and start swayidle
if [[ "${1:-}" == "init" ]]; then
  TIMEOUT_MIN="${2:-$DEFAULT_MINUTES}"
  rm -f "$LOCK_FILE"
  start_swayidle "$TIMEOUT_MIN"
  exit 0
fi

TIMEOUT_MIN="${1:-$DEFAULT_MINUTES}"

# If the lock file exists, it means Keep-Awake is currently active. Remove the lock file and restart swayidle with the specified timeout.
if [ -f "$LOCK_FILE" ]; then
  rm -f "$LOCK_FILE"
  start_swayidle "$TIMEOUT_MIN"

  notify-send -a "Power" -u normal -t 2000 \
    -h string:x-canonical-private-synchronous:keep-awake \
    -i preferences-desktop-screensaver \
    "Keep Awake" "disabled (auto lock after ${TIMEOUT_MIN} minutes)"
  exit 0
fi

# If the lock file does not exist, it means Keep-Awake is currently inactive. Create the lock file and stop swayidle to prevent auto-locking.
touch "$LOCK_FILE"
pkill -x "swayidle" 2>/dev/null || true

notify-send -a "Power" -u normal -t 2000 \
  -h string:x-canonical-private-synchronous:keep-awake \
  -i display-brightness \
  "Keep Awake" "enabled (screen always on)"