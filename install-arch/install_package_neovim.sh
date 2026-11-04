#!/usr/bin/env bash

# --- COLOR DEFINITIONS ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
LAVENDER='\033[0;35m'
NC='\033[0m'

# ==============================================================================
# NEOVIM & LAZYVIM DEPENDENCY INSTALLER (ARCH LINUX)
# ==============================================================================

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}      NEOVIM & LAZYVIM ENVIRONMENT INSTALLER        ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# ------------------------------------------------------------------------------
# PACKAGE LIST FOR A FULL NEOVIM & LAZYVIM EXPERIENCE
# ------------------------------------------------------------------------------
NEOVIM_PACKAGES=(
    "neovim"               # Core Neovim editor (v0.10+)
    "git"                  # Package manager backend for lazy.nvim
    "gcc" "make"           # Compilers for Treesitter C/C++ parsers
    "unzip" "curl"         # Utilities for Mason server downloads
    "ripgrep"              # Ultra-fast grep engine for Snacks/Telescope
    "fd"                   # Fast file search alternative to find
    "fzf"                  # Fuzzy finder integration
    "nodejs" "npm"         # Language server runtime (tsserver, pyright, etc.)
    "python-pynvim"        # Python provider for Neovim plugins
    "xclip" "wl-clipboard" # Clipboard provider for X11 & Wayland
)

# ------------------------------------------------------------------------------
# EXECUTE INSTALLATION
# ------------------------------------------------------------------------------
echo -e "${YELLOW}[1/1] Installing Neovim and build dependencies...${NC}"
sudo pacman -S --needed --noconfirm "${NEOVIM_PACKAGES[@]}"

# ------------------------------------------------------------------------------
# COMPLETION SUMMARY
# ------------------------------------------------------------------------------
echo -e "\n${BLUE}====================================================${NC}"
echo -e "${GREEN}✅ NEOVIM & VIM-STACK ENVIRONMENT IS FULLY EQUIPPED!${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "${LAVENDER}👉 Launch Neovim using 'nvim' to auto-bootstrap LazyVim plugins.${NC}"
