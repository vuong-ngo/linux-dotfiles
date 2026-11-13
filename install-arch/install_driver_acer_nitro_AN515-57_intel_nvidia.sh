#!/usr/bin/env bash

# --- COLOR DEFINITIONS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}            Arch Hybrid Driver Toolkit              ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# Automatically detect and match kernel headers with the currently running kernel
CURRENT_KERNEL=$(uname -r)
if [[ "$CURRENT_KERNEL" == *"-zen"* ]]; then
    KERNEL_HEADERS="linux-zen-headers"
elif [[ "$CURRENT_KERNEL" == *"-lts"* ]]; then
    KERNEL_HEADERS="linux-lts-headers"
else
    KERNEL_HEADERS="linux-headers"
fi

# ------------------------------------------------------------------------------
# DRIVER & SYSTEM PACKAGES (INTEL + NVIDIA GTX 1650)
# ------------------------------------------------------------------------------
ESSENTIAL_TOOLS=(
    # --- Kernel Headers & Microcode ---
    "$KERNEL_HEADERS"         # REQUIRED to build nvidia-dkms, acpi_call-dkms, v4l2loopback-dkms
    "intel-ucode"             # Intel CPU microcode updates for improved stability and security

    # --- NVIDIA GTX 1650 & Hybrid Offload ---
    "nvidia-dkms"             # NVIDIA proprietary DKMS driver
    "nvidia-utils"            # NVIDIA utilities for OpenGL and Vulkan support
    "lib32-nvidia-utils"      # 32-bit NVIDIA utilities for gaming/Steam/Wine compatibility
    "nvidia-settings"         # NVIDIA configuration tool
    "nvidia-prime"            # Provides prime-run command for on-demand discrete GPU offload
    "egl-wayland"             # Mandatory Wayland EGL bridge for Niri + NVIDIA
    "libva-nvidia-driver"     # NVIDIA VA-API hardware video acceleration
    "opencl-nvidia"           # OpenCL support for GPU compute workloads

    # --- Intel iGPU & Graphics APIs ---
    "mesa"                    # Open-source graphics drivers for Intel integrated graphics
    "lib32-mesa"              # 32-bit Mesa drivers
    "mesa-utils"              # Utilities for testing OpenGL performance (glxinfo)
    "vulkan-intel"            # Vulkan drivers for Intel integrated graphics
    "lib32-vulkan-intel"      # 32-bit Vulkan drivers for Intel integrated graphics
    "vulkan-icd-loader"       # Vulkan Installable Client Driver loader
    "lib32-vulkan-icd-loader" # 32-bit Vulkan ICD loader
    "intel-media-driver"      # Intel VA-API hardware video decoding for Gen 8+ GPUs
    "libva-utils"             # Utilities for testing VA-API acceleration (vainfo)
    "vdpauinfo"               # Tool for querying VDPAU capabilities

    # --- Audio (PipeWire & Firmware) ---
    "sof-firmware"            # Sound Open Firmware required for modern Intel laptops
    "alsa-ucm-conf"           # ALSA Use Case Manager configuration for proper audio routing
    "alsa-utils"              # ALSA utilities for managing audio devices (alsamixer)
    "alsa-firmware"           # Additional firmware for audio hardware support
    "pipewire"                # Modern low-latency audio/video server
    "pipewire-jack"           # PipeWire JACK compatibility layer
    "pipewire-pulse"          # PipeWire PulseAudio replacement
    "pipewire-alsa"           # PipeWire ALSA compatibility layer
    "wireplumber"             # Modular session and policy manager for PipeWire

    # --- Network, Bluetooth & Bus ---
    "networkmanager"          # Network connection manager (Wi-Fi / Ethernet)
    "bluez"                   # Official Linux Bluetooth protocol stack
    "bluez-utils"             # Bluetooth CLI utilities (bluetoothctl)
    "dbus-broker"             # High-performance D-Bus message broker
    "dbus-broker-units"       # Systemd service units for dbus-broker

    # --- Input, Power & Thermal ---
    "libinput"                # Input device handling library for Wayland
    "xf86-input-libinput"     # XWayland input driver wrapper
    "thermald"                # Intel Thermal Daemon for dynamic CPU temperature control
    "lm_sensors"              # Hardware monitoring tools for temperature and fan speed
    "upower"                  # Battery and power source status monitoring daemon
    "acpid"                   # ACPI event daemon (lid switch, power button events)
    "acpi_call-dkms"          # DKMS module for ACPI calls (e.g., battery charge thresholds)
    "power-profiles-daemon"   # Power profile switcher (performance, balanced, power-saver)
    "irqbalance"              # Distributes hardware interrupts across CPU cores

    # --- Storage, Filesystems & Utilities ---
    "nvme-cli"                # NVMe SSD management and health CLI tools
    "exfatprogs"              # Userspace utilities for exFAT filesystems (replaces exfat-utils)
    "ntfs-3g"                 # NTFS read/write filesystem driver
    "dosfstools"              # FAT32 filesystem utilities (USB drives, EFI partitions)
    "v4l2loopback-dkms"       # DKMS module for virtual webcam devices (OBS/Zoom)
    "usbutils"                # USB device inspection utilities (lsusb)
    "pciutils"                # PCI device inspection utilities (lspci)
    "xdg-user-dirs"           # Standard user directory generator (Downloads, Documents, etc.)
    "ufw"                     # Uncomplicated Firewall for system security
)

# ------------------------------------------------------------------------------
# EXECUTE INSTALLATION
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[1/3] Syncing databases and deploying driver ecosystem...${NC}"
sudo pacman -Syu --needed "${ESSENTIAL_TOOLS[@]}"

# ------------------------------------------------------------------------------
# ENABLE SYSTEMD SERVICES
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[2/3] Enabling system services...${NC}"
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable dbus-broker.service
sudo systemctl enable power-profiles-daemon
sudo systemctl enable thermald
sudo systemctl enable acpid
sudo systemctl enable irqbalance
sudo systemctl enable upower
sudo systemctl enable ufw
sudo systemctl enable fstrim.timer

# Enable Btrfs scrub timers only if the corresponding mount points use Btrfs
if findmnt -n -o FSTYPE / | grep -q "btrfs"; then
    sudo systemctl enable btrfs-scrub@-.timer
    findmnt -n -o FSTYPE /home | grep -q "btrfs" && sudo systemctl enable btrfs-scrub@home.timer
fi

# Note: Keep nvidia-persistenced disabled on hybrid laptops so GTX 1650 can enter D3cold sleep
# sudo systemctl enable nvidia-persistenced

# ------------------------------------------------------------------------------
# COMPLETION
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}[3/3] ✅ SYSTEM IS READY FOR WORK!${NC}"
echo -e "${BLUE}====================================================${NC}"