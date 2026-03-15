#!/bin/bash

###########################################################
# PROJECT:  EXOCORE SYSTEM MASTER DEPLOYMENT
# AUTHOR:   Choru Official (Johnsteve Costanos)
# TARGET:   ~/.config/install.sh
###########################################################

# Color variables
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# ASCII Banner
clear
echo -e "${CYAN}"
echo "  ███████╗██╗  ██╗ ██████╗  ██████╗ ██████╗ ██████╗ ███████╗"
echo "  ██╔════╝╚██╗██╔╝██╔═══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝"
echo "  █████╗   ╚███╔╝ ██║   ██║██║     ██║   ██║██████╔╝█████╗  "
echo "  ██╔══╝   ██╔██╗ ██║   ██║██║     ██║   ██║██╔══██╗██╔══╝  "
echo "  ███████╗██╔╝ ██╗╚██████╔╝╚██████╗╚██████╔╝██║  ██║███████╗"
echo "  ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
echo -e "              ${BLUE}MASTER AUTO-DEPLOYMENT v2.0${NC}"
echo -e "${BLUE}==========================================================${NC}"

# 1. Setup Temp Directory & Clone Repo
echo -e "\n${YELLOW}󰇚 [1/5] Cloning Google-Pixel-Hyprland Repo...${NC}"
REPO_URL="https://github.com/ChoruOfficial/Google-Pixel-Hyprland"
TEMP_DIR="/tmp/google-pixel-hyprland"

rm -rf $TEMP_DIR # Clean old files

if git clone $REPO_URL $TEMP_DIR; then
    echo -e "${GREEN}✔ Repository cloned successfully.${NC}"
else
    echo -e "${RED}✘ Failed to clone repository. Check internet connection.${NC}"
    exit 1
fi

# 2. Deploy Configs
echo -e "\n${YELLOW}󰆐 [2/5] Deploying configurations to ~/.config/...${NC}"
mkdir -p ~/.config

# Copy folders and replace existing
cp -rf $TEMP_DIR/fish ~/.config/
cp -rf $TEMP_DIR/hypr ~/.config/
cp -rf $TEMP_DIR/kitty ~/.config/
cp -rf $TEMP_DIR/waybar ~/.config/

echo -e "${GREEN}✔ Configs replaced and updated.${NC}"

# 3. Set Permissions
echo -e "\n${YELLOW}󰧿 [3/5] Setting execution permissions...${NC}"
chmod +x ~/.config/waybar/scripts/*.js
chmod +x ~/.config/waybar/install.sh 2>/dev/null
chmod +x ~/.config/fish/install.sh 2>/dev/null

# 4. Run Fish Engine Installer
echo -e "\n${YELLOW}󰈺 [4/5] Initializing Fish Shell Engine...${NC}"
if [ -f "$HOME/.config/fish/install.sh" ]; then
    bash $HOME/.config/fish/install.sh
    echo -e "${GREEN}✔ Fish engine setup complete.${NC}"
else
    echo -e "${RED}✘ Fish installer not found!${NC}"
fi

# 5. Final Handover to Waybar Installer
echo -e "\n${YELLOW}󱐋 [5/5] Starting Waybar Exocore Installer...${NC}"
echo -e "${BLUE}----------------------------------------------------------${NC}"

if [ -f "$HOME/.config/waybar/install.sh" ]; then
    bash $HOME/.config/waybar/install.sh
else
    echo -e "${RED}✘ Waybar installer not found in ~/.config/waybar/install.sh${NC}"
    exit 1
fi

# Cleanup
rm -rf $TEMP_DIR

echo -e "\n${BLUE}==========================================================${NC}"
echo -e "${GREEN}   MASTER DEPLOYMENT FINISHED!${NC}"
echo -e "${CYAN}   Author: Johnsteve Costanos (Choru Official)${NC}"
echo -e "${BLUE}==========================================================${NC}"
