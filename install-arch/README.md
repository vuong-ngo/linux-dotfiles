# 🛠️ Arch Linux Automated Setup Toolkit (`install-arch/`)

A modular suite of production-grade shell scripts designed for automated installation, system optimization, package deployment, and hardware configuration on **Arch Linux**.

![Arch Linux](https://img.shields.io/badge/OS-Arch_Linux-blue?logo=arch-linux)
![Shell-Bash-green?logo=gnu-bash](https://img.shields.io/badge/Shell-Bash-green?logo=gnu-bash)
![Package_Manager-pacman_%26_yay-orange](https://img.shields.io/badge/Package_Manager-pacman_%26_yay-orange)

---

## 📂 Installation Scripts Manifest

Every script in this directory is self-contained, color-coded, and idempotent (safe to run multiple times without duplicating packages).

| Script File | Target Component | Description & Key Packages |
| :--- | :--- | :--- |
| **[`install_grub.sh`](./install_grub.sh)** | GRUB Bootloader (UEFI) | Installs `grub` & `efibootmgr`, verifies UEFI mode & mounted `vfat` ESP, installs GRUB to EFI, and generates `/boot/grub/grub.cfg`. |
| **[`install_yay_AUR.sh`](./install_yay_AUR.sh)** | AUR Helper | Bootstraps `yay` AUR helper from official source (`base-devel`, `git`). |
| **[`install_WM_niri.sh`](./install_WM_niri.sh)** | Niri Environment | Installs `niri`, `xwayland-satellite`, `rofi-wayland`, `swaync`, `swaybg`, `hyprlock`, `hypridle`, `cliphist`, `foot`, `brightnessctl`, `pavucontrol`, `wlsunset`. |
| **[`install_WM_hyprland.sh`](./install_WM_hyprland.sh)** | Hyprland Environment | Installs `hyprland`, `xdg-desktop-portal-hyprland`, `waybar`, `rofi-wayland`, `swaync`, `hyprlock`, `hypridle`, `hyprshot`. |
| **[`install_DE_gnome.sh`](./install_DE_gnome.sh)** | GNOME Desktop | Deploys minimal GNOME desktop (`gnome-shell`, `nautilus`, `gdm`, `gnome-control-center`). |
| **[`install_DE_KDE.sh`](./install_DE_KDE.sh)** | KDE Plasma Desktop | Deploys minimal KDE Plasma environment (`plasma-desktop`, `sddm`, `konsole`, `dolphin`). |
| **[`install_driver_acer_nitro_AN515-57_intel_nvidia.sh`](./install_driver_acer_nitro_AN515-57_intel_nvidia.sh)** | Hybrid GPU & Hardware Drivers | Configures Intel CPU microcode, NVIDIA DKMS drivers (`nvidia-dkms`, `vulkan-intel`, `vulkan-icd-loader`), PipeWire audio stack, Intel Thermal Daemon (`thermald`), and power management (`upower`, `acpid`). |
| **[`install_fcitx5_bamboo.sh`](./install_fcitx5_bamboo.sh)** | Vietnamese Input Engine (Bamboo) | Installs `fcitx5`, `fcitx5-bamboo`, `fcitx5-configtool`, `fcitx5-gtk`, and `fcitx5-qt`. |
| **[`install_fcitx5_unikey.sh`](./install_fcitx5_unikey.sh)** | Vietnamese Input Engine (Unikey) | Installs `fcitx5`, `fcitx5-unikey`, `fcitx5-configtool`, `fcitx5-gtk`, and `fcitx5-qt`. |
| **[`install_package_gtk.sh`](./install_package_gtk.sh)** | GTK Tools & Monitors | Deploys `nwg-look`, `fastfetch`, `btop`, `nvtop`, `tmux`, `gnome-disk-utility`, `loupe`, `mpv`, and `xclip`. |
| **[`install_shell_zsh.sh`](./install_shell_zsh.sh)** | Zsh Shell Setup | Installs `zsh`, `starship`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, and switches default login shell. |
| **[`install_zram.sh`](./install_zram.sh)** | ZRAM Memory Optimizer | Configures `zram-generator` allocating 50% RAM compressed with `zstd` algorithm and sysctl swappiness parameters. |

---

## 🚀 Execution & Usage Guide

### Step 1: Bootstrap AUR Helper (`yay`)
If you are starting from a fresh Arch Linux base installation, bootstrap `yay` first:
```bash
chmod +x install_yay_AUR.sh
./install_yay_AUR.sh
```

### Step 2: Make Scripts Executable
Ensure execution permissions are set on target scripts:
```bash
chmod +x install_grub.sh install_WM_niri.sh install_shell_zsh.sh
```

### Step 3: Run Target Installation Script
Run the desired component script. Root privileges will be requested safely via `sudo`:
```bash
./install_WM_niri.sh
```

---

## 🛡️ Safety & Best Practices
- **Pacman Flag Safety**: Scripts use `pacman -S --needed` to avoid dangerous partial system upgrades (`pacman -Sy` alone is avoided per Arch Wiki guidelines).
- **Idempotent Design**: Running any script again will safely skip packages already installed on your system.
- **Hardware Agnostic**: Component scripts like `install_grub.sh` and `install_shell_zsh.sh` work on all hardware, while driver scripts are tailored for Intel + NVIDIA hybrid laptops.

## NVIDIA Configuration (GRUB & Initramfs)

### 1. Kernel Parameters (`/etc/default/grub`)
Add the NVIDIA DRM and power management flags to `GRUB_CMDLINE_LINUX_DEFAULT`:

```ini
GRUB_CMDLINE_LINUX_DEFAULT="nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1"
```

### 2. Initramfs Modules (`/etc/mkinitcpio.conf`)
Add early KMS modules to `MODULES`:

```ini
MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
```

Then regenerate both configs:

```bash
sudo mkinitcpio -P
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
