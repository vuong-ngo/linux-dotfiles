#!/usr/bin/env bash

# --- COLOR DEFINITIONS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
LAVENDER='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- COLOR CODES ---
echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}   ZRAM AUTO-INSTALLATION & OPTIMIZATION (ARCH) ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# 1. Install core package
echo -e "${YELLOW}[1/5] Downloading zram-generator from pacman repository...${NC}"
sudo pacman -S --needed zram-generator

# 2. Write optimized configuration to the system
echo -e "${YELLOW}[2/5] Creating config: Allocating 50% RAM, using zstd compression algorithm...${NC}"
sudo tee /etc/systemd/zram-generator.conf >/dev/null <<EOF
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF

# 3. Reload systemd and activate the device
echo -e "${YELLOW}[3/5] Reloading systemd daemon and starting zram...${NC}"
sudo systemctl daemon-reload
sudo systemctl restart systemd-zram-setup@zram0.service

# 4. Optimize Kernel parameters for ZRAM (NEW)
echo -e "${YELLOW}[4/5] Optimizing Kernel Sysctl parameters for ZRAM...${NC}"
sudo tee /etc/sysctl.d/99-zram.conf >/dev/null <<EOF
vm.swappiness = 100
vm.page-cluster = 0
EOF
# Apply sysctl parameters immediately without rebooting
sudo sysctl --system >/dev/null 2>&1

# 5. Check the results
echo -e "${YELLOW}[5/5] Current system Swap & ZRAM statistics:${NC}"
echo -e "${CYAN}--- ZRAM CTL ---${NC}"
zramctl
echo -e "${CYAN}--- SWAP PRIORITY CHECK ---${NC}"
swapon --show
echo -e "----------------------------------------------------\n"

echo -e "${GREEN}✅ AWESOME! Compressed RAM system is now running smoothly with max priority.${NC}"
