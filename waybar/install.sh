#!/bin/bash

# * ---------------------------------------------------------
# * PROJECT:  EXOCORE SYSTEM DEPLOYMENT (MODULAR)
# * AUTHOR:   Choru Official (Johnsteve Costanos)
# * VERSION:  1.3.1
# * ---------------------------------------------------------


# Color variables
G1='\033[38;5;39m'  # Light Blue
G2='\033[38;5;45m'  # Cyan-ish
G3='\033[38;5;51m'  # Bright Cyan
G4='\033[38;5;81m'  # Sky Blue
G5='\033[38;5;111m' # Soft Blue
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Spinner function for aesthetic loading
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Run a command with spinner
run_with_spinner() {
    "$@" &
    local pid=$!
    spinner $pid
    wait $pid
}

clear
# Gradient Banner
echo -e "${G1}  ███████╗ ██╗  ██╗ ██████╗  ██████╗ ██████╗  ██████╗ ███████╗"
echo -e "${G2}  ██╔════ ╝╚██╗██╔╝██╔═══██╗██╔════╝ ██╔═══██╗██╔══██╗██╔════╝"
echo -e "${G3}  █████╗    ╚███╔╝ ██║   ██║██║      ██║   ██║██████╔╝█████╗  "
echo -e "${G4}  ██╔══╝    ██╔██╗ ██║   ██║██║      ██║   ██║██╔══██╗██╔══╝  "
echo -e "${G5}  ███████╗ ██╔╝ ██╗╚██████╔╝╚██████╗╚██████╔╝ ██║  ██║███████╗"
echo -e "${G5}  ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
echo -e "           ${PURPLE}PREMIUM MODULAR DEPLOYMENT v1.3.1${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo -e "${NC}  AUTHOR: ${GREEN}Johnsteve Costanos (Choru Official)${NC}"
echo -e "${BLUE}==========================================================${NC}"

# 1. Directory Structure
echo -e "\n${YELLOW}󰉖 [1/5] Initializing Exocore structure...${NC}"
run_with_spinner mkdir -p ~/.config/waybar/{modules,themes,scripts,assets/backgrounds}
echo -e "${GREEN}✔ File system ready.${NC}"

# 2. Dependencies via YAY
echo -e "\n${YELLOW}󰂖 [2/5] Installing core dependencies (yay)...${NC}"
run_with_spinner yay -S --noconfirm --needed waybar swww git nodejs rofi bluez bluez-utils blueman
echo -e "${GREEN}✔ Dependencies installed.${NC}"

# 3. Bluetooth Service
echo -e "\n${YELLOW}󰂱 [3/5] Activating Bluetooth engine...${NC}"
run_with_spinner sudo systemctl enable --now bluetooth
echo -e "${GREEN}✔ Bluetooth service online.${NC}"

# 4. Asset Synchronization
echo -e "\n${YELLOW}󰋩 [4/5] Synchronizing cloud assets (Wallpapers)...${NC}"
REPO="https://github.com/ChoruOfficial/Pixel-Google-Image.git"
ASSET_DIR="$HOME/.config/waybar/assets/backgrounds"

if [ ! -d "$ASSET_DIR/.git" ]; then
    run_with_spinner git clone "$REPO" "$ASSET_DIR"
else
    run_with_spinner bash -c "cd '$ASSET_DIR' && git pull"
fi
echo -e "${GREEN}✔ Assets synchronized to local storage.${NC}"

# 5. Configuration Injection
echo -e "\n${YELLOW}󱧿 [5/5] Injecting Exocore modules...${NC}"
run_with_spinner bash -c "
    cp ./config.jsonc ~/.config/waybar/ &&
    cp ./modules/*.json ~/.config/waybar/modules/ &&
    cp ./themes/*.css ~/.config/waybar/themes/ &&
    cp ./scripts/*.js ~/.config/waybar/scripts/ &&
    chmod +x ~/.config/waybar/scripts/*.js
"
echo -e "${GREEN}✔ Configuration deployed successfully.${NC}"

# Initialization
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
fi

# Initial Theme Run
node ~/.config/waybar/scripts/theme.js

echo -e "\n${BLUE}==========================================================${NC}"
echo -e "${GREEN}   SYSTEM STATUS: ONLINE & OPTIMIZED${NC}"
echo -e "${G3}   All modules and assets are now modularized.${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo -e "${PURPLE}   Stay Peak, Boss Choru!${NC}\n"
