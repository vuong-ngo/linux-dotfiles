#!/usr/bin/env bash

# ============================================================
# Script: Toggle Niri Keybinds State
# Description: Toggles Niri keybindings between Normal and Passthrough modes
# ============================================================

show_help() {
  cat <<EOF
Usage: $(basename "$0") [OPTION]

Description:
  Switches Niri keybindings symlink between normal keybindings
  and passthrough mode (for virtual machines or remote desktop).

Options:
  -h, --help    Show this help message and exit

Examples:
  $(basename "$0")       Toggle keybinds mode
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  show_help
  exit 0
fi

DIR="$HOME/.config/niri/config.d"
ON="$DIR/keybinds-on.kdl"
OFF="$DIR/keybinds-off.kdl"
ACTIVE="$DIR/keybinds.kdl"

if [ "$(readlink "$ACTIVE")" = "$OFF" ]; then
  ln -sf "$ON" "$ACTIVE"
  notify-send -a "Niri" -u normal -t 1500 \
    -h string:x-canonical-private-synchronous:niri-keybinds \
    -i input-keyboard-symbolic \
    "Keybindings" "Normal Mode (Enabled)"
else
  ln -sf "$OFF" "$ACTIVE"
  notify-send -a "Niri" -u normal -t 1500 \
    -h string:x-canonical-private-synchronous:niri-keybinds \
    -i input-keyboard-symbolic \
    "Keybindings" "Passthrough Mode (Disabled)"
fi
