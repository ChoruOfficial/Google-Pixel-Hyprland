#!/bin/bash

###########################################################
# PROJECT:  EXOCORE SYSTEM INSTALLER (PREMIUM)
# AUTHOR:   Choru Official (Johnsteve Costanos)
# VERSION:  1.3.1 (Global Sync Integrated)
###########################################################

# Color variables
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

# ASCII Art & Banner
clear
echo -e "${CYAN}"
echo "  ███████╗██╗  ██╗ ██████╗  ██████╗ ██████╗ ██████╗ ███████╗"
echo "  ██╔════╝╚██╗██╔╝██╔═══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo "  █████╗    ╚███╔╝ ██║   ██║██║      ██║   ██║██████╔╝█████╗  "
echo "  ██╔══╝    ██╔██╗ ██║   ██║██║      ██║   ██║██╔══██╗██╔══╝  "
echo "  ███████╗██╔╝ ██╗╚██████╔╝╚██████╗╚██████╔╝██║  ██║███████╗"
echo "  ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
echo -e "           ${PURPLE}PREMIUM SYSTEM DEPLOYMENT v1.3.1${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo -e "${NC}  AUTHOR: ${GREEN}Johnsteve Costanos (Choru Official)${NC}"
echo -e "${BLUE}==========================================================${NC}"

spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# 1. Arch Check
if ! [ -f /etc/arch-release ]; then
    echo -e "${RED}[ERROR] This environment is not Arch Linux. Aborting.${NC}"
    exit 1
fi

# 2. Dependency Installation (Updated with Sync Tools)
echo -e "\n${YELLOW}󰂖 [1/5] Initializing core dependencies & sync tools...${NC}"
# Kasama na dito ang kvantum, nwg-look, at portals para sa Dolphin/Chrome sync
CORE="waybar swww git nodejs npm rofi ttf-jetbrains-mono-nerd"
SYNC_TOOLS="kvantum qt5ct qt6ct nwg-look xdg-desktop-portal-hyprland xdg-desktop-portal-gtk"
(sudo pacman -S --noconfirm --needed $CORE $SYNC_TOOLS) & spinner
echo -e "${GREEN}✔ Core and Sync dependencies installed.${NC}"

# 3. Directory Preparation
echo -e "\n${YELLOW}󰉖 [2/5] Structuring Exocore directories...${NC}"
(mkdir -p ~/.config/waybar/scripts && mkdir -p ~/Pictures/Pixel-Google-Image) & spinner
echo -e "${GREEN}✔ File system ready.${NC}"

# 4. Wallpaper Syncing
echo -e "\n${YELLOW}󰋩 [3/5] Synchronizing cloud assets (Wallpapers)...${NC}"
REPO_URL="https://github.com/ChoruOfficial/Pixel-Google-Image.git"
if [ ! -d "$HOME/Pictures/Pixel-Google-Image/.git" ]; then
    (git clone $REPO_URL ~/Pictures/Pixel-Google-Image) & spinner
else
    (cd ~/Pictures/Pixel-Google-Image && git pull) & spinner
fi
echo -e "${GREEN}✔ Assets synchronized.${NC}"

# 5. Config Deployment
echo -e "\n${YELLOW}󱧿 [4/5] Injecting Exocore configuration modules...${NC}"
(
    # Copy waybar configs
    cp ./config.jsonc ~/.config/waybar/ 2>/dev/null
    cp ./scripts/*.js ~/.config/waybar/scripts/ 2>/dev/null
    chmod +x ~/.config/waybar/scripts/*.js

    # Siguraduhin na executable ang theme-engine.js
    if [ -f ~/.config/waybar/scripts/theme.js ]; then
        chmod +x ~/.config/waybar/scripts/theme.js
    fi
) & spinner
echo -e "${GREEN}✔ Configurations deployed.${NC}"

# 6. Final Initialization
echo -e "\n${YELLOW}󱐋 [5/5] Powering up the Exocore engine...${NC}"
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 2
fi

# Run initial theme sync
(node ~/.config/waybar/scripts/theme.js) & spinner

# Success Message
echo -e "\n${BLUE}==========================================================${NC}"
echo -e "${GREEN}   SYSTEM STATUS: ONLINE & OPTIMIZED${NC}"
echo -e "${CYAN}   Global Sync (GTK/Qt/Electron) is now active.${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo -e "${PURPLE}   Stay Peak, Boss Choru! Reboot is recommended.${NC}\n"
