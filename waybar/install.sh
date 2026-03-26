#!/bin/bash

# * ---------------------------------------------------------
# * PROJECT:  EXOCORE SYSTEM DEPLOYMENT (MODULAR FIXED)
# * AUTHOR:   Choru Official (Johnsteve Costanos)
# * VERSION:  1.4.0
# * ---------------------------------------------------------

# Color variables
G1='\033[38;5;39m'
G2='\033[38;5;45m'
G3='\033[38;5;51m'
G4='\033[38;5;81m'
G5='\033[38;5;111m'
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

run_with_spinner() {
    "$@" &
    local pid=$!
    spinner $pid
    wait $pid
}

clear

echo -e "${G1}  ███████╗ ██╗  ██╗ ██████╗  ██████╗ ██████╗  ██████╗ ███████╗"
echo -e "${G2}  ██╔════ ╝╚██╗██╔╝██╔═══██╗██╔════╝ ██╔═══██╗██╔══██╗██╔════╝"
echo -e "${G3}  █████╗    ╚███╔╝ ██║   ██║██║      ██║   ██║██████╔╝█████╗  "
echo -e "${G4}  ██╔══╝    ██╔██╗ ██║   ██║██║      ██║   ██║██╔══██╗██╔══╝  "
echo -e "${G5}  ███████╗ ██╔╝ ██╗╚██████╔╝╚██████╗╚██████╔╝ ██║  ██║███████╗"
echo -e "${G5}  ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
echo -e "           ${PURPLE}EXOCORE DEPLOYMENT v1.4.0${NC}"

# 1. Structure
echo -e "\n${YELLOW}󰉖 [1/7] Initializing structure...${NC}"
run_with_spinner mkdir -p ~/.config/waybar/{modules,themes,scripts,assets/backgrounds}
echo -e "${GREEN}✔ Structure ready.${NC}"

# 2. Dependencies (yay + node + npm)
echo -e "\n${YELLOW}󰂖 [2/7] Installing dependencies...${NC}"
run_with_spinner yay -S --noconfirm --needed \
waybar swww git nodejs npm rofi bluez bluez-utils blueman
echo -e "${GREEN}✔ Dependencies installed.${NC}"

# Node check
echo -e "\n${YELLOW}󰂖 Checking Node environment...${NC}"
node -v || echo "Node missing"
npm -v || echo "npm missing"

# 3. Bluetooth
echo -e "\n${YELLOW}󰂱 [3/7] Enabling Bluetooth...${NC}"
run_with_spinner sudo systemctl enable --now bluetooth
echo -e "${GREEN}✔ Bluetooth online.${NC}"

# 4. Assets
echo -e "\n${YELLOW}󰋩 [4/7] Syncing wallpapers...${NC}"
REPO="https://github.com/ChoruOfficial/Pixel-Google-Image.git"
ASSET_DIR="$HOME/.config/waybar/assets/backgrounds"

if [ ! -d "$ASSET_DIR/.git" ]; then
    run_with_spinner git clone "$REPO" "$ASSET_DIR"
else
    run_with_spinner bash -c "cd '$ASSET_DIR' && git pull"
fi
echo -e "${GREEN}✔ Assets synced.${NC}"

# 5. Config injection
echo -e "\n${YELLOW}󱧿 [5/7] Deploying configs...${NC}"
run_with_spinner bash -c "
    cp ./config.jsonc ~/.config/waybar/ &&
    cp ./modules/*.json ~/.config/waybar/modules/ &&
    cp ./themes/*.css ~/.config/waybar/themes/ &&
    cp ./scripts/*.js ~/.config/waybar/scripts/ &&
    chmod +x ~/.config/waybar/scripts/*.js
"
echo -e "${GREEN}✔ Config deployed.${NC}"

# 6. Compatibility Layer (AWWW ↔ SWWW)
echo -e "\n${YELLOW}󰂖 [6/7] Creating wallpaper compatibility layer...${NC}"

sudo tee /usr/local/bin/swww > /dev/null << 'EOF'
#!/bin/bash
exec awww "$@"
EOF

sudo tee /usr/local/bin/swww-daemon > /dev/null << 'EOF'
#!/bin/bash
exec awww-daemon "$@"
EOF

sudo chmod +x /usr/local/bin/swww /usr/local/bin/swww-daemon
echo -e "${GREEN}✔ Compatibility layer ready.${NC}"

# 7. Daemon startup
echo -e "\n${YELLOW}󰂖 [7/7] Starting wallpaper daemon...${NC}"

if ! pgrep -x "awww-daemon" > /dev/null && ! pgrep -x "swww-daemon" > /dev/null; then
    awww-daemon &
fi

# Run theme engine
node ~/.config/waybar/scripts/theme.js

echo -e "\n${BLUE}==========================================================${NC}"
echo -e "${GREEN} SYSTEM STATUS: ONLINE & OPTIMIZED${NC}"
echo -e "${PURPLE} EXOCORE DEPLOYMENT COMPLETE${NC}"
echo -e "${BLUE}==========================================================${NC}"
