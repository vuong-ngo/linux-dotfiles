#!/usr/bin/env bash
set -euo pipefail

# --- COLOR DEFINITIONS ---
BLUE='\033[0;34m'
LAVENDER='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ==============================================================================
# TERMINAL COLOR CODES
# ==============================================================================

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}     ULTIMATE ZSH AUTO-INSTALLER (ARCH)            ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# ------------------------------------------------------------------------------
# STEP 1: Install core dependencies
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[1/3] Installing core packages: Zsh, Git, Curl, Wget...${NC}"
sudo pacman -S --needed --noconfirm zsh startship git curl wget less tree gawk

# ------------------------------------------------------------------------------
# STEP 2: Change the default shell
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[2/3] Changing default shell to Zsh...${NC}"
chsh -s $(which zsh)

# ------------------------------------------------------------------------------
# STEP 3: Download Productivity Plugins
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[3/3] Downloading Autosuggestions...${NC}"
ZSH_CUSTOM="$HOME/.config/zsh"

# Clone essential plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting

echo -e "\n${GREEN}✅ SUCCESS! Your Zsh machine is ready.${NC}"
echo -e "${YELLOW}👉 Please LOG OUT and LOG BACK IN for the changes to take effect.${NC}"
