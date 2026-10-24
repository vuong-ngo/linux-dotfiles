#!/usr/bin/env bash

# ============================================================
# Script: Rofi Application Launcher
# Platform: Arch Linux x Niri (Wayland)
# ============================================================

set -euo pipefail

THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/scripts/app-launcher/app-launcher.rasi"
if [ ! -f "$THEME" ]; then
    THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/config.rasi"
fi

exec rofi -normal-window -show drun -theme "$THEME"
