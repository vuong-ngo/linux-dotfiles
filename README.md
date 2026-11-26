# 🌌 Arch Linux x Niri Wayland Dotfiles

A modular, keyboard-driven, high-performance dotfiles configuration built for **Arch Linux**, featuring the **Niri Wayland Scrollable Window Manager**, **Foot / Ghostty / Kitty / Alacritty Terminals**, **Tmux**, **Rofi Rasi Menus**, **Neovim IDE (`vim-stack`)**, and **Catppuccin Mocha / Graphite Minimalist Aesthetics**.

![Arch Linux](https://img.shields.io/badge/OS-Arch_Linux-blue?logo=arch-linux)
![Compositor-Niri_Wayland-cyan](https://img.shields.io/badge/Compositor-Niri_Wayland-cyan)
![Theme-Catppuccin_Mocha-purple](https://img.shields.io/badge/Theme-Catppuccin_Mocha-purple)
![Editor-Neovim_v0.10+-green?logo=neovim](https://img.shields.io/badge/Editor-Neovim_v0.10+-green?logo=neovim)
![Terminals-Foot_%7C_Ghostty-black](https://img.shields.io/badge/Terminals-Foot_%7C_Ghostty-black)
![License-MIT-yellow](https://img.shields.io/badge/License-MIT-yellow)

---

## 📐 Repository Structure & Architecture

The repository is modularly structured into core configuration buckets (`dotfiles-global`, `dotfiles-niri`, and `install-arch`) for clean deployment via symlinking:

```text
linux-dotfiles/
├── README.md                              # Main repository documentation & guide
├── LICENSE                                # MIT License
├── dotfiles-global/                       # Portable global CLI/GUI configurations
│   ├── README.md                          # Global tools overview & details
│   ├── .zshrc                             # Zsh profile, vi-mode, aliases & plugins
│   └── .config/
│       ├── terminal/                      # Unified Catppuccin Mocha Black terminal configs
│       │   ├── foot/                      # Foot terminal config (foot.ini)
│       │   ├── ghostty/                   # Ghostty config + subtle cursor_trail.glsl shader
│       │   ├── kitty/                     # Kitty config
│       │   └── alacritty/                 # Alacritty config
│       ├── Code/                          # VS Code user settings & keybindings
│       ├── fastfetch/                     # Lightweight Arch system fetch theme
│       ├── fcitx5/                        # Vietnamese input method config
│       ├── pipewire/                      # PipeWire audio configuration
│       ├── tmux/                          # Tmux multiplexer config & guide
│       ├── zsh/                           # Zsh plugins directory
│       ├── brave-flags.conf               # Wayland flags for Brave
│       ├── electron-flags.conf            # Wayland flags for Electron apps
│       ├── gamemode.ini                   # GameMode optimization config
│       └── starship.toml                  # Starship prompt theme
├── dotfiles-niri/                         # Wayland desktop environment configurations
│   ├── README.md                          # Desktop environment setup guide
│   └── .config/
│       ├── hypr/                          # Hyprlock screen locker configuration
│       ├── niri/                          # Niri compositor config & helper scripts
│       ├── rofi/                          # Rofi menus (Clipboard, Power, Wallpaper)
│       └── swaync/                        # Sway Notification Center styles
└── install-arch/                          # Automated Arch Linux installer scripts
    ├── README.md                          # Installer scripts guide & manifest
    ├── install_grub.sh                    # UEFI GRUB bootloader installer & verifier
    ├── install_yay_AUR.sh                 # Bootstraps yay AUR helper from source
    ├── install_WM_niri.sh                 # Full Niri Wayland ecosystem installer
    ├── install_WM_hyprland.sh             # Full Hyprland ecosystem installer
    ├── install_DE_gnome.sh                # Minimal GNOME desktop installer
    ├── install_DE_KDE.sh                  # Minimal KDE Plasma desktop installer
    ├── install_driver_acer_nitro_...sh    # Intel + NVIDIA hybrid drivers
    ├── install_fcitx5_bamboo.sh           # Vietnamese input method (Bamboo)
    ├── install_fcitx5_unikey.sh           # Vietnamese input method (Unikey)
    ├── install_package_gtk.sh             # GTK tools & system monitors installer
    ├── install_shell_zsh.sh               # Zsh, Starship & plugins installer
    └── install_zram.sh                    # ZRAM compressed memory optimizer
```

---

## ✨ Core Features & Technical Highlights

### 1. Niri Wayland Window Manager (`dotfiles-niri`)
- **Scrollable Tiling Layout**: Unlimited horizontal workspace scrolling with dynamic column sizing.
- **Physics-Based Animations**: Smooth spring curve physics for window switching and workspace scrolling.
- **Glassmorphism & Transparency**: Transparent terminal backgrounds (`0.9` opacity) with rounded geometry.
- **Automated Helper Scripts**: Scripts in `dotfiles-niri/.config/niri/scripts/` for volume, brightness, power modes, airplane mode, night light, and wallpaper switching.

### 2. Unified Terminal Suite (`dotfiles-global/.config/terminal`)
- **Consistent Aesthetics**: All 4 terminals (**Foot**, **Ghostty**, **Kitty**, **Alacritty**) share `JetBrainsMono Nerd Font` (12pt), Catppuccin Mocha Black (`#08080c`), `0.9` opacity, and block cursor.
- **Ghostty Cursor Trail Shader**: Custom single-pass GLSL shader (`shaders/cursor_trail.glsl`) providing a smooth, VS Code-style cursor glide (`0.26s`, soft Lavender fade) without distracting bloom.
- **Tmux-First Philosophy**: Terminal tab bars and redundant split shortcuts are disabled so **Tmux** cleanly owns all panes, tabs, and long scrollback history (`50,000` lines).
- **Kitty over SSH**: See the [Kitty, SSH and Codex setup](dotfiles-global/.config/tmux/README.md#kitty-ssh-and-codex) for terminal images and Pets.

### 3. Neovim & Vim Stack (`vim-stack` External Repository)
- **Dedicated Repository**: Neovim and Vim configurations are modularly managed in **[vuong-ngo/vim-stack](https://github.com/vuong-ngo/vim-stack.git)**.
- **Ultra-Fast Neovim IDE**: Built on LazyVim with `blink.cmp` autocompletion, Mason LSP, Treesitter, `snacks.nvim`, on-demand formatting via `conform.nvim` (`<leader>cf`), and CSV/Markdown viewers.
- **Zero-Plugin Native Vim**: Pure stock Vimscript setup (`vim/.vimrc`) with native `gcc`/`gc` commenting, Catppuccin Mocha transparent theme, and `<Space>` leader key parity.

### 4. Tmux Multiplexer (`dotfiles-global/.config/tmux`)
- **Vi Copy Mode & System Clipboard**: Integrated Vi selection (`v`, `V`, `Ctrl+v`, `y`) with external clipboard support.
- **Zero Typing Interference**: Pane operations use the Prefix key (`Ctrl+a`), while fast window switching uses `Alt + Shift + H / L`.
- **Custom Dual-Tone Status Bar**: Top-anchored graphite bar showing active mode (`NORMAL`, `PREFIX`, `VISUAL`), session badge, and Bufferline-style window tabs.

### 5. Rofi Rasi Modules (`dotfiles-niri/.config/rofi`)
- **Clipboard Manager**: Integrated `cliphist` manager with permanent pinning (`Alt+P`), item deletion/unpinning (`Alt+D` / `Alt+X`), and `Clear All History`.
- **Power Menu & Wallpaper Picker**: Minimalist launchers for lock/suspend/reboot/poweroff and live wallpaper switching with `swaybg`.

---

## ⌨️ Global Keybindings Reference

### 🖥️ Niri Window Manager
| Shortcut | Action |
| :--- | :--- |
| `Super + Return` | Open Terminal |
| `Super + D` / `Super + Space` | Launch Rofi Application Menu |
| `Super + V` | Open Rofi Clipboard Manager |
| `Super + X` | Open Rofi Power Menu |
| `Super + W` | Open Rofi Wallpaper Picker |
| `Super + Q` | Close Active Window |
| `Super + H / J / K / L` | Move Window Focus (Left / Down / Up / Right) |
| `Super + Shift + H / J / K / L` | Move Window Position |
| `Super + R` | Resize Window Columns |
| `Super + F` | Toggle Window Fullscreen |
| `Super + Shift + F` | Toggle Window Floating State |

### ⚡ Neovim (`vim-stack`)
| Shortcut | Action |
| :--- | :--- |
| `<Space>` | Leader Key |
| `H` / `L` | Switch to Previous / Next Buffer |
| `<leader>e` | Toggle Sidebar Explorer |
| `Ctrl + P` / `<leader>ff` | Find Files |
| `<leader>fg` | Search Text in Project (Grep) |
| `<leader>ca` | LSP Code Action |
| `<leader>rn` | LSP Rename Symbol |
| `<leader>cf` | Format Document |
| `gcc` / `gc` | Toggle Line / Visual Comment |
| `Ctrl + /` | Toggle Integrated Floating Terminal |

### 📟 Tmux Terminal Multiplexer
| Shortcut | Action |
| :--- | :--- |
| `Ctrl + a` | Prefix Key |
| `Prefix, h / j / k / l` | Focus Left / Down / Up / Right Pane |
| `Alt + Shift + H / L` | Switch to Previous / Next Window |
| `Prefix, \|` | Split Window Vertically |
| `Prefix, -` | Split Window Horizontally |
| `Prefix, Shift + H / J / K / L` | Resize Active Pane |
| `Prefix, v` | Enter Vim-Style Copy Mode |
| `Prefix, r` | Reload Tmux Configuration |

### 📋 Rofi Clipboard Manager
| Shortcut | Action |
| :--- | :--- |
| `Enter` | Copy selected item to clipboard & exit |
| `Alt + P` | Pin selected item permanently (preserves across clears) |
| `Alt + D` / `Alt + X` | Delete item from history / Unpin pinned item |
| `Row 0 (Red Highlight)` | `🚨 CLEAR ALL HISTORY` (Clears unpinned history) |

---

## 🛠️ Automated Setup & Installation

### Option 1: Automated Installation via `install-arch/`
If you are setting up a fresh Arch Linux system, use the modular scripts in [`install-arch/`](./install-arch/README.md):

```bash
# 1. Clone dotfiles & vim-stack repositories
git clone https://github.com/vuong-ngo/dotfiles.git ~/dotfiles
git clone https://github.com/vuong-ngo/vim-stack.git ~/vim-stack

# 2. Install AUR helper (yay)
cd ~/dotfiles/install-arch
chmod +x install_yay_AUR.sh
./install_yay_AUR.sh

# 3. Install Niri Wayland Environment & Shell
chmod +x install_WM_niri.sh install_shell_zsh.sh
./install_WM_niri.sh
./install_shell_zsh.sh
```

---

### Option 2: Manual Symlinking Deployment

```bash
# 1. Symlink Global Configurations
ln -sfn ~/dotfiles/dotfiles-global/.config/terminal/foot ~/.config/foot
ln -sfn ~/dotfiles/dotfiles-global/.config/terminal/ghostty ~/.config/ghostty
ln -sfnT ~/dotfiles/dotfiles-global/.config/terminal/kitty ~/.config/kitty
ln -sfnT ~/dotfiles/dotfiles-global/.config/tmux ~/.config/tmux
ln -sfn ~/dotfiles/dotfiles-global/.zshrc ~/.zshrc

# 2. Symlink Niri Desktop Configurations
cp -rs ~/dotfiles/dotfiles-niri/.config/* ~/.config/

# 3. Symlink Vim & Neovim Stack
ln -sfn ~/vim-stack/nvim ~/.config/nvim
ln -sfn ~/vim-stack/vim/.vimrc ~/.vimrc

# 4. Reload Shell & Niri Compositor
source ~/.zshrc
niri msg action load-config-file
```

---

## 📜 License
This repository is licensed under the [MIT License](./LICENSE). Free to use, modify, and distribute.
