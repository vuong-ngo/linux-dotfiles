#!/usr/bin/env bash

# ============================================================
# Script: Rofi NVIDIA App Launcher (PRIME offload)
# Platform: Arch Linux x Niri (Wayland)
# ============================================================

set -euo pipefail

THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/scripts/nvidia-launcher/nvidia-launcher.rasi"

if ! command -v prime-run &> /dev/null; then
    notify-send -a "NVIDIA" -u normal -t 3000 -i dialog-error-symbolic "NVIDIA Error" "prime-run tool not found"
    exit 1
fi

exec rofi -normal-window -show drun \
    -theme "$THEME" \
    -run-list-command ". $HOME/.bashrc" \
    -run-command "prime-run {cmd}" \
    -display-drun "󰍛 GPU" \
    -drun-display-format "{name}"
