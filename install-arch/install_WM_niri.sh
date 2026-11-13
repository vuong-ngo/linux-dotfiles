#!/usr/bin/env bash

# --- COLOR DEFINITIONS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
LAVENDER='\033[0;35m'
NC='\033[0m'

# ==============================================================================
# TERMINAL COLOR CODES
# ==============================================================================

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}    NIRI ECOSYSTEM INSTALLER (SWAY TOOLS EDITION)   ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# ------------------------------------------------------------------------------
# 1. PACKAGE LIST FOR A FULL NIRI & HARDWARE EXPERIENCE
# ------------------------------------------------------------------------------
NIRI_PACKAGES=(
    # --- Core Compositor, Wayland Protocols & X11 Fallback ---
    "niri"                      # Core Wayland compositor
    "xwayland-satellite"        # Virtual X11 server for legacy apps (Discord, etc.)
    "xorg-xwayland"             # Core XWayland library
    "xdg-desktop-portal"        # Core portal communication
    "xdg-desktop-portal-gnome"  # Crucial for screen sharing on Niri
    "xdg-desktop-portal-gtk"    # Required for file picker dialogs & dark mode theme propagation
    "qt5-wayland" "qt6-wayland" # Native Wayland support for Qt apps

    # --- File Manager ---
    "gvfs" "gvfs-mtp" # Trash support, network mounting, and mobile devices

    # --- Desktop Environment & UI Components ---
    "rofi"                # Application launcher
    "swaync"              # Notification daemon & Control Center
    "swaybg"              # Wallpaper daemon
    "hyprlock" "swayidle" # HYPRLAND LOCKING & IDLE MANAGEMENT

    # --- System Infrastructure & Hardware Integration ---
    "foot"                    # GPU-accelerated terminal emulator
    "polkit-gnome"            # Graphical password prompts for root access
    "wl-clipboard" "cliphist" # Clipboard manager & history
    "brightnessctl"           # CLI for display brightness
    "jq"                      # JSON processor (required for wl-mirror output parsing)
    "libnotify"               # Desktop notifications library
    "wlsunset"                # Blue light filter
    "wl-mirror"               # Mirror screen
)

# ------------------------------------------------------------------------------
# 2. CLEANUP CONFLICTING PORTALS (CRITICAL FOR SCREEN SHARE)
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[1/2] Removing conflicting portals (Hyprland/Wlroots)...${NC}"
sudo pacman -Rns --noconfirm xdg-desktop-portal-hyprland xdg-desktop-portal-wlr 2>/dev/null || true

# ------------------------------------------------------------------------------
# 3. EXECUTE INSTALLATION
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}[2/2] Installing Niri ecosystem and Sway tools...${NC}"
sudo pacman -S --needed --noconfirm "${NIRI_PACKAGES[@]}"

echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}✅ NIRI SYSTEM IS FULLY EQUIPPED!${NC}"
echo -e "${BLUE}====================================================${NC}"
