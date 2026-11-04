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
echo -e "${GREEN}                   Driver Toolkit                    ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# ------------------------------------------------------------------------------
# DRIVER INSTALLATION (INTEL + NVIDIA)
# ------------------------------------------------------------------------------
ESSENTIAL_TOOLS=(
    "intel-ucode"             # Intel CPU microcode updates for improved stability and security
    "nvidia-dkms"             # NVIDIA proprietary drivers for optimal performance on GTX 1650
    "nvidia-utils"            # NVIDIA utilities for OpenGL and Vulkan support
    "nvidia-settings"         # NVIDIA configuration tool for display settings
    "mesa"                    # Open-source graphics drivers for Intel integrated graphics
    "lib32-mesa"              # 32-bit version of Mesa for compatibility with 32-bit applications
    "mesa-utils"              # Utilities for testing OpenGL performance and configuration
    "lib32-nvidia-utils"      # 32-bit NVIDIA utilities for compatibility with 32-bit applications
    "vulkan-intel"            # Vulkan drivers for Intel integrated graphics
    "lib32-vulkan-intel"      # 32-bit Vulkan drivers for Intel integrated graphics
    "vulkan-icd-loader"       # Vulkan Installable Client Driver loader
    "lib32-vulkan-icd-loader" # 32-bit Vulkan ICD loader for compatibility with 32-bit applications
    "opencl-nvidia"           # OpenCL support for NVIDIA GPUs for compute workloads
    "intel-media-driver"      # Intel media driver for hardware-accelerated video decoding
    "libva-utils"             # Utilities for testing VA-API video acceleration
    "vdpauinfo"               # Tool for querying VDPAU capabilities of NVIDIA GPUs
    "sof-firmware"            # Sound Open Firmware for audio support on Intel platforms
    "alsa-ucm-conf"           # ALSA Use Case Manager configuration for better audio support
    "pipewire"                # Modern audio and video server for better multimedia handling
    "pipewire-jack"           # PipeWire JACK compatibility layer for professional audio applications
    "pipewire-pulse"          # PipeWire PulseAudio compatibility layer
    "pipewire-alsa"           # PipeWire ALSA compatibility layer
    "wireplumber"             # Session manager for PipeWire for better multimedia session handling
    "alsa-utils"              # ALSA utilities for managing audio devices and settings
    "alsa-firmware"           # ALSA firmware for better hardware support
    "bluez"                   # Bluetooth protocol stack for Linux
    "bluez-utils"             # Utilities for managing Bluetooth devices
    "networkmanager"          # NetworkManager for managing network connections
    "xf86-input-libinput"     # libinput driver for X.Org for better input device support
    "libinput"                # Library for handling input devices
    "thermald"                # Intel Thermal Daemon for better thermal management
    "lm_sensors"              # Hardware monitoring tools for temperature and fan speed
    "nvme-cli"                # Command-line interface for managing NVMe SSDs
    "upower"                  # Power management tool for monitoring battery and power status
    "acpid"                   # Advanced Configuration and Power Interface daemon for handling power events
    "acpi_call-dkms"          # DKMS module for executing ACPI calls (e.g., for battery management)
    "irqbalance"              # Daemon for balancing IRQ load across CPU cores for better performance
    "exfat-utils"             # Utilities for managing exFAT file systems (e.g., for external drives)
    "ntfs-3g"                 # NTFS file system driver for Linux (for external drives formatted with NTFS)
    "v4l2loopback-dkms"       # DKMS module for creating virtual video devices (e.g., for webcam emulation)
    "usbutils"                # Utilities for managing USB devices
    "pciutils"                # Utilities for managing PCI devices
    "xdg-user-dirs"           # Tool for managing user directories (e.g., Documents, Downloads)
    "power-profiles-daemon"   # Daemon for managing power profiles (e.g., performance, balanced, power-saver)
    "ufw"                     # Firewall management tool for securing the system
)

# ------------------------------------------------------------------------------
# EXECUTE INSTALLATION
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[1/3] Syncing databases and deploying driver ecosystem...${NC}"
sudo pacman -S --needed "${ESSENTIAL_TOOLS[@]}"

# ------------------------------------------------------------------------------
# START SYSTEMCTL
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[2/3] Enable daemon service..."
sudo systemctl enable NetworkManager
sudo systemctl enable fstrim.timer
sudo systemctl enable thermald
sudo systemctl enable acpid
sudo systemctl enable irqbalance
sudo systemctl enable nvidia-persistenced
sudo systemctl enable dbus-broker
sudo systemctl enable btrfs-scrub@-.timer
sudo systemctl enable btrfs-scrub@home.timer
sudo systemctl enable ufw
sudo systemctl enable upower

# ------------------------------------------------------------------------------
# COMPLETION
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}[3/3] ✅ SYSTEM IS READY FOR WORK!${NC}"
echo -e "${BLUE}====================================================${NC}"
