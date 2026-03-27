#!/bin/bash
sudo -v
# * ---------------------------------------------------------
# * PROJECT:  EXOCORE SYSTEM MASTER DEPLOYMENT
# * AUTHOR:   Choru Official (Johnsteve Costanos)
# * VERSION:  2.3.0 (Auto-Yay + Extra Tools Integrated)
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

# Spinner function
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

clear

# Banner
echo -e "${G1}  ███████╗ ██╗  ██╗ ██████╗  ██████╗ ██████╗  ██████╗ ███████╗"
echo -e "${G2}  ██╔════ ╝╚██╗██╔╝██╔═══██╗██╔════╝ ██╔═══██╗██╔══██╗██╔════╝"
echo -e "${G3}  █████╗    ╚███╔╝ ██║   ██║██║      ██║   ██║██████╔╝█████╗  "
echo -e "${G4}  ██╔══╝    ██╔██╗ ██║   ██║██║      ██║   ██║██╔══██╗██╔══╝  "
echo -e "${G5}  ███████╗ ██╔╝ ██╗╚██████╔╝╚██████╗╚██████╔╝ ██║  ██║███████╗"
echo -e "${G5}  ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
echo -e "           ${PURPLE}MASTER AUTO-DEPLOYMENT v2.3.0${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo -e "${NC}  AUTHOR: ${GREEN}Johnsteve Costanos (Choru Official)${NC}"
echo -e "${BLUE}==========================================================${NC}"

# --- PRE-INSTALLATION CHECK ---

# Git
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}󰊢 Git not found. Installing...${NC}"
    sudo pacman -S --noconfirm git & spinner
else
    echo -e "${GREEN}✔ Git installed.${NC}"
fi

# Fish shell (NEW)
if ! command -v fish &> /dev/null; then
    echo -e "${YELLOW}🐟 Fish shell not found. Installing...${NC}"
    sudo pacman -S --noconfirm fish & spinner
else
    echo -e "${GREEN}✔ Fish shell installed.${NC}"
fi

# Yay
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}󰂖 Installing Yay...${NC}"
    sudo pacman -S --noconfirm --needed base-devel & spinner
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd - && rm -rf /tmp/yay
    echo -e "${GREEN}✔ Yay installed.${NC}"
else
    echo -e "${GREEN}✔ Yay already installed.${NC}"
fi

# --- FONTS (NEW ADDITION) ---
echo -e "\n${YELLOW}󰛖 Installing Nerd Fonts...${NC}"
sudo pacman -S --noconfirm \
ttf-jetbrains-mono-nerd \
ttf-firacode-nerd \
ttf-hack-nerd & spinner
echo -e "${GREEN}✔ Fonts installed.${NC}"

# --- CORE PACKAGES ---
echo -e "\n${YELLOW}󰂖 Installing Core Packages...${NC}"
SYNC_PACKS="wofi kvantum qt5ct qt6ct nwg-look xdg-desktop-portal-hyprland xdg-desktop-portal-gtk waybar swww nodejs bluez bluez-utils blueman"
(yay -S --noconfirm --needed $SYNC_PACKS) & spinner
echo -e "${GREEN}✔ Core packages installed.${NC}"

# --- REPO CLONE ---
echo -e "\n${YELLOW}󰇚 Cloning repository...${NC}"
REPO_URL="https://github.com/ChoruOfficial/Google-Pixel-Hyprland"
TEMP_DIR="/tmp/google-pixel-hyprland"
rm -rf $TEMP_DIR
(git clone $REPO_URL $TEMP_DIR) & spinner
echo -e "${GREEN}✔ Repo cloned.${NC}"

# --- CONFIG DEPLOY ---
echo -e "\n${YELLOW}󰆐 Deploying configs...${NC}"
mkdir -p ~/.config
cp -rf $TEMP_DIR/fish ~/.config/
cp -rf $TEMP_DIR/hypr ~/.config/
cp -rf $TEMP_DIR/kitty ~/.config/
cp -rf $TEMP_DIR/waybar ~/.config/
echo -e "${GREEN}✔ Configs deployed.${NC}"

# --- PERMISSIONS ---
echo -e "\n${YELLOW}󰧿 Setting permissions...${NC}"
chmod +x ~/.config/waybar/scripts/*.js
chmod +x ~/.config/waybar/install.sh
chmod +x ~/.config/fish/install.sh
chmod +x ~/.config/install.sh
echo -e "${GREEN}✔ Permissions set.${NC}"

# --- SERVICES ---
echo -e "\n${YELLOW}󰈺 Starting services...${NC}"
sudo systemctl enable --now bluetooth

if [ -f "$HOME/.config/fish/install.sh" ]; then
    bash "$HOME/.config/fish/install.sh"
fi

if [ -f "$HOME/.config/waybar/install.sh" ]; then
    bash "$HOME/.config/waybar/install.sh"
fi

echo -e "${GREEN}✔ Services ready.${NC}"

# --- EXTRA TOOLS ---
echo -e "\n${YELLOW}󰇚 Installing extra tools...${NC}"
EXTRA_PACKS="cmatrix cava peaclock htop"
(yay -S --noconfirm --needed $EXTRA_PACKS) & spinner
echo -e "${GREEN}✔ Extra tools installed.${NC}"

# --- CLEANUP ---
echo -e "\n${YELLOW}󱐋 Cleaning up...${NC}"
rm -rf $TEMP_DIR
echo -e "${GREEN}✔ Cleanup done.${NC}"

# FINAL
echo -e "\n${BLUE}==========================================================${NC}"
echo -e "${GREEN}   MASTER DEPLOYMENT FINISHED!${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo -e "${PURPLE}   REBOOT IS RECOMMENDED${NC}\n"
