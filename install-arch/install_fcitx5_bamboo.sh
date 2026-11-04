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
echo -e "${GREEN}    VIETNAMESE TYPING ENGINE INSTALLER (FCITX5)     ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# ------------------------------------------------------------------------------
# PACKAGE LIST FOR WAYLAND COMPATIBILITY
# ------------------------------------------------------------------------------
FCITX5_PACKAGES=(
    "fcitx5"            # The core input method framework
    "fcitx5-configtool" # GUI configuration tool (very important)
    "fcitx5-gtk"        # Support for GTK applications (GNOME apps, Thunar, etc.)
    "fcitx5-qt"         # Support for Qt applications (KDE apps, Telegram, etc.)
    "fcitx5-bamboo"     # The absolute best Vietnamese input engine (Telex/VNI)
)

# ------------------------------------------------------------------------------
# EXECUTE INSTALLATION
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[1/2] Syncing databases and installing Fcitx5 ecosystem...${NC}"

# CHANGED: Use -S instead of -Sy to comply with Arch Linux safety standards
# Added --noconfirm for a smoother unattended installation flow
sudo pacman -S --needed "${FCITX5_PACKAGES[@]}"

# ------------------------------------------------------------------------------
# COMPLETION
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}[2/2] ✅ INSTALLATION COMPLETE!${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "${YELLOW}👉 Remember to add environment variables to your /etc/environment or config.${NC}"
echo -e "${LAVENDER}👉 Run 'fcitx5-configtool' to manually add the Bamboo engine and start typing!${NC}"
