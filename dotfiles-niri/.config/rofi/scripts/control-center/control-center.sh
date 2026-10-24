#!/usr/bin/env bash

# ============================================================
# Script: Rofi Control Center / Quick Settings
# Platform: Arch Linux x Niri (Wayland)
# ============================================================

set -euo pipefail

NIRI_SCRIPTS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/niri/scripts"
THEME="${XDG_CONFIG_HOME:-$HOME/.config}/rofi/scripts/control-center/control-center.rasi"

get_night_light_status() {
    if pgrep -x "wlsunset" >/dev/null 2>&1; then
        echo "ON (4500K)"
    else
        echo "OFF"
    fi
}

get_keep_awake_status() {
    if [ -f "/tmp/keep_awake.lock" ]; then
        echo "ACTIVE (No Sleep)"
    else
        echo "OFF (Normal)"
    fi
}

get_airplane_status() {
    local wifi_state
    wifi_state=$(nmcli radio wifi 2>/dev/null || echo "disabled")
    if [ "$wifi_state" = "enabled" ]; then
        echo "OFF (Online)"
    else
        echo "ON (Offline)"
    fi
}

get_power_profile() {
    if command -v powerprofilesctl >/dev/null 2>&1; then
        powerprofilesctl get 2>/dev/null || echo "balanced"
    else
        echo "balanced"
    fi
}

get_extreme_saver_status() {
    if [ -f "/tmp/niri_power_save_active" ]; then
        echo "ACTIVE (20% Throttled)"
    else
        echo "OFF"
    fi
}

get_battery_status() {
    local bat_path cap
    bat_path=$(find /sys/class/power_supply/ -name "BAT*" 2>/dev/null | head -n 1)
    if [ -n "$bat_path" ] && [ -f "$bat_path/capacity" ]; then
        cap=$(cat "$bat_path/capacity")
        echo "${cap}%"
    else
        echo "100%"
    fi
}

get_keybinds_status() {
    local active_link
    active_link="${XDG_CONFIG_HOME:-$HOME/.config}/niri/config.d/keybinds.kdl"
    if [ -L "$active_link" ] && [[ "$(readlink "$active_link")" == *"keybinds-off.kdl"* ]]; then
        echo "Passthrough"
    else
        echo "Normal"
    fi
}

build_menu() {
    local nl_status ka_status ap_status pwr_mode xs_status bat_cap kb_status
    nl_status=$(get_night_light_status)
    ka_status=$(get_keep_awake_status)
    ap_status=$(get_airplane_status)
    pwr_mode=$(get_power_profile)
    xs_status=$(get_extreme_saver_status)
    bat_cap=$(get_battery_status)
    kb_status=$(get_keybinds_status)

    cat <<EOF
󰖔  Night Light (Warm Eye Care): ${nl_status}
󰤄  Keep Awake (Inhibit Sleep): ${ka_status}
󰀝  Airplane Mode: ${ap_status}
󰾆  CPU Power Profile: ${pwr_mode^^} (Click to cycle)
󱐋  Extreme Battery Saver: ${xs_status}
󰌌  Niri Keybinds Mode: ${kb_status}
󰁹  Battery & Power Status: ${bat_cap}
󰍛  Launch App on NVIDIA GPU (prime-run)
  Wallpaper Selector
󰅌  Clipboard History Manager
  System Power Menu
EOF
}

main() {
    local selected
    selected=$(build_menu | rofi -normal-window -dmenu -i -p "Control Center" -theme "$THEME")

    [ -z "$selected" ] && exit 0

    case "$selected" in
        *"Night Light"*)
            bash "$NIRI_SCRIPTS_DIR/night_light.sh"
            ;;
        *"Keep Awake"*)
            bash "$NIRI_SCRIPTS_DIR/keep_awake.sh"
            ;;
        *"Airplane Mode"*)
            bash "$NIRI_SCRIPTS_DIR/airplane_mode.sh"
            ;;
        *"CPU Power Profile"*)
            local cur_mode next_mode
            cur_mode=$(get_power_profile)
            case "$cur_mode" in
                performance) next_mode="balanced" ;;
                balanced) next_mode="power-saver" ;;
                *) next_mode="performance" ;;
            esac
            bash "$NIRI_SCRIPTS_DIR/power_mode.sh" "$next_mode"
            ;;
        *"Extreme Battery Saver"*)
            bash "$NIRI_SCRIPTS_DIR/power_saved.sh"
            ;;
        *"Niri Keybinds Mode"*)
            bash "$NIRI_SCRIPTS_DIR/toggle_keybinds.sh"
            ;;
        *"Battery & Power Status"*)
            bash "$NIRI_SCRIPTS_DIR/show_pin.sh"
            ;;
        *"NVIDIA GPU"*)
            bash "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/scripts/nvidia-launcher/nvidia-launcher.sh"
            ;;
        *"Wallpaper Selector"*)
            bash "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/scripts/wallpaper-picker/wallpaper-picker.sh"
            ;;
        *"Clipboard History"*)
            bash "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/scripts/clipboard-manager/clipboard-manager.sh"
            ;;
        *"System Power Menu"*)
            bash "${XDG_CONFIG_HOME:-$HOME/.config}/rofi/scripts/power-menu/power-menu.sh"
            ;;
        *)
            exit 0
            ;;
    esac
}

main "$@"
