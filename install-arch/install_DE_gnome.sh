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
echo -e "${GREEN}         GNOME-LITE INSTALLER (MINIMAL)            ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# ------------------------------------------------------------------------------
# THE "ZERO-BLOAT" PACKAGE LIST
# ------------------------------------------------------------------------------
GNOME=(
    # --- Core Desktop Shell ---
    "gnome-shell" # The heart of GNOME (no extra apps)
    "gdm"         # Login manager

    # --- Critical System Settings (Hardware Control) ---
    "gnome-control-center" # The main Settings app (Wifi, Bluetooth, Display)

    # --- Essential Services (The "Backbone") ---
    "gnome-keyring"     # Auto-unlock passwords for WiFi/GitHub
    "xdg-user-dirs-gtk" # Creates Downloads, Documents, etc.
    "networkmanager"    # Core network service

    # --- Theming Bridge ---
    "gsettings-desktop-schemas" # Gsettings for GTK and GNOME Shell
)

# ------------------------------------------------------------------------------
# EXECUTE DEPLOYMENT
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[1/3] Syncing databases and deploying GNOME-Shell core...${NC}"
sudo pacman -Sy --needed "${GNOME[@]}"

echo -e "\n${YELLOW}[2/3] Enabling GDM Service...${NC}"
sudo systemctl enable gdm

# ------------------------------------------------------------------------------
# COMPLETION
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}[3/3] ✅ GNOME LITE IS READY!${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "${YELLOW}👉 Profile: Deep Navy & Mint Ready${NC}"
echo -e "\n${YELLOW}👉 Next steps:${NC}"
echo -e "1. Reboot. Choose 'GNOME on Wayland' at the login screen."
echo -e "2. Use 'gnome-control-center' to manage your hardware."
