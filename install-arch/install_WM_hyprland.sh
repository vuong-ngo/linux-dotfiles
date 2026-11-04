#!/usr/bin/env bash

# --- COLOR DEFINITIONS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
LAVENDER='\033[0;35m'
NC='\033[0m'

# ==============================================================================
# TERMINAL COLOR CODES
# ==============================================================================

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}      HYPRLAND ECOSYSTEM INSTALLER (ULTIMATE)       ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# ------------------------------------------------------------------------------
# PACKAGE LIST FOR A FULL HYPRLAND & HARDWARE EXPERIENCE
# ------------------------------------------------------------------------------
HYPR_PACKAGES=(
    # --- Core Compositor & Wayland Protocols ---
    "hyprland"                    # Core Wayland compositor (Main environment)
    "xdg-desktop-portal-hyprland" # Crucial for screen sharing and app communication
    "qt5-wayland" "qt6-wayland"   # Ensures Qt5/Qt6 apps run natively on Wayland

    # --- Thunar File Manager & Enhanced Plugins (Dolphin-like features) ---
    "gvfs" "gvfs-mtp" # Trash support, network mounting, and mobile devices

    # --- Desktop Environment & UI Components ---
    "waybar"              # Highly customizable status bar
    "rofi-wayland"        # Dynamic application launcher & menu
    "swaync"              # Notification daemon with built-in control center
    "swaybg"              # Lower-performance wallpaper daemon (animated)
    "hyprlock" "hypridle" # Modern screen locking and idle/sleep management

    # --- System Infrastructure & Hardware Integration ---
    "foot"                    # GPU-accelerated terminal emulator
    "polkit-gnome"            # Provides graphical password prompts (Auth)
    "wl-clipboard" "cliphist" # System clipboard manager and history
    "hyprshot"                # Efficient screenshot tool tailored for Hyprland
    "brightnessctl"           # CLI for controlling display brightness
    "pavucontrol"             # GUI for PulseAudio/Pipewire volume management
    "blueman"                 # GUI for managing Bluetooth connections
    "libnotify"               # Core library for sending desktop notifications
    "wlsunset"                # Night light/Blue light filter for Wayland
)

# ------------------------------------------------------------------------------
# EXECUTE INSTALLATION
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[1/3] Syncing repositories and deploying ecosystem...${NC}"
sudo pacman -S --needed --noconfirm "${HYPR_PACKAGES[@]}"

# ------------------------------------------------------------------------------
# COMPLETION SUMMARY
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}✅ HYPRLAND SYSTEM IS FULLY EQUIPPED!${NC}"
echo -e "${BLUE}====================================================${NC}"
