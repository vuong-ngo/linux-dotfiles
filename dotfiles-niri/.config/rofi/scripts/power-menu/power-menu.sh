#!/usr/bin/env bash

# ============================================================
# Script: Rofi Power Menu (Graphite Glass & JetBrainsMono Icons)
# Platform: Arch Linux x Niri (Wayland)
# Tools: hyprlock / gtklock, swaync, systemctl
# ============================================================

lock_screen() {
    if command -v hyprlock >/dev/null 2>&1; then
        hyprlock
    elif command -v gtklock >/dev/null 2>&1; then
        gtklock
    fi
}

# JetBrainsMono Nerd Font v3 Icons
lock="󰌾"
logout="󰍃"
sleep_opt="󰤄"
hibernate="󰒲"
reboot="󰑓"
shutdown="󰐥"

options="$lock\n$logout\n$sleep_opt\n$hibernate\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | rofi -dmenu -i -p "󰐥 " \
    -theme ~/.config/rofi/scripts/power-menu/power-menu.rasi)"

case "$chosen" in
    "$lock")
        lock_screen
        ;;
    "$logout")
        niri msg action quit --skip-confirmation
        ;;
    "$sleep_opt")
        swaync-client -cp &
        lock_screen & 
        sleep 0.5
        systemctl suspend
        ;;
    "$hibernate")
        swaync-client -cp &
        lock_screen &
        sleep 0.5
        systemctl hibernate
        ;;
    "$reboot")
        systemctl reboot
        ;;
    "$shutdown")
        systemctl poweroff
        ;;
esac
