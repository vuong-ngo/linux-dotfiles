#!/usr/bin/env bash
set -euo pipefail

# --- COLOR DEFINITIONS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- BANNER ---
echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}                   GRUB (ARCH)                     ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# 0. Pre-flight checks: UEFI mode & privilege helper
if [[ ! -d /sys/firmware/efi ]]; then
    echo -e "${RED}Error: System is not booted in UEFI mode (/sys/firmware/efi not found).${NC}"
    echo -e "${YELLOW}This script only supports UEFI x86_64 systems. Aborting.${NC}"
    exit 1
fi

SUDO=""
if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    if ! command -v sudo >/dev/null 2>&1; then
        echo -e "${RED}Error: Please run as root or install sudo.${NC}"
        exit 1
    fi
    SUDO="sudo"
fi

# 1. Install core packages
echo -e "${YELLOW}[1/4] Installing GRUB & efibootmgr...${NC}"
$SUDO pacman -S --needed grub efibootmgr

# 2. Detect mounted FAT32 EFI System Partition and run grub-install
echo -e "${YELLOW}[2/4] Detecting EFI System Partition and running grub-install...${NC}"
EFI_DIR=""
for dir in "/boot/efi" "/efi" "/boot"; do
    if mountpoint -q "$dir" 2>/dev/null; then
        if command -v findmnt >/dev/null 2>&1; then
            fstype=$(findmnt -n -o FSTYPE "$dir" 2>/dev/null || true)
            if [[ "$fstype" == "vfat" ]]; then
                EFI_DIR="$dir"
                break
            fi
        else
            EFI_DIR="$dir"
            break
        fi
    fi
done

if [[ -z "$EFI_DIR" ]]; then
    echo -e "${RED}Error: No mounted FAT32 (vfat) EFI partition found at /boot/efi, /efi, or /boot.${NC}"
    echo -e "${YELLOW}Please mount your EFI System Partition first (e.g. 'sudo mount /dev/nvme0n1p1 /boot/efi') and re-run.${NC}"
    exit 1
fi

echo -e "${CYAN}Installing GRUB to ${EFI_DIR}...${NC}"
$SUDO grub-install --target=x86_64-efi --efi-directory="$EFI_DIR" --bootloader-id=GRUB

# 3. Generate GRUB configuration file
echo -e "${YELLOW}[3/4] Generating /boot/grub/grub.cfg...${NC}"
$SUDO grub-mkconfig -o /boot/grub/grub.cfg

# 4. Verify installation
echo -e "${YELLOW}[4/4] Verifying EFI boot entry & grub.cfg:${NC}"
echo -e "${CYAN}--- EFIBOOTMGR ---${NC}"
if command -v efibootmgr >/dev/null 2>&1 && [[ -d /sys/firmware/efi/efivars ]]; then
    efibootmgr | grep -i "GRUB" || echo -e "${YELLOW}Warning: GRUB entry not found in efibootmgr output.${NC}"
else
    echo -e "${YELLOW}Skipping efibootmgr check (efivars not accessible).${NC}"
fi

echo -e "${CYAN}--- GRUB.CFG CHECK ---${NC}"
if [[ ! -s /boot/grub/grub.cfg ]]; then
    echo -e "${RED}Error: /boot/grub/grub.cfg is missing or empty!${NC}"
    exit 1
fi
ls -lh /boot/grub/grub.cfg
echo -e "----------------------------------------------------\n"
echo -e "${GREEN}✅ DONE! GRUB has been installed and configured successfully.${NC}"
