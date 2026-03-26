#!/bin/bash
sudo -v
# * ---------------------------------------------------------
# * PROJECT:  EXOCORE SYSTEM MASTER DEPLOYMENT
# * AUTHOR:   Choru Official (Johnsteve Costanos)
# * VERSION:  2.3.0 (Auto-Yay + Extra Tools Integrated)
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
# Gradient Banner
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

# --- PRE-INSTALLATION CHECK (GIT & YAY) ---

# Check and Install Git
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}󰊢 Git not found. Installing via pacman...${NC}"
    sudo pacman -S --noconfirm git & spinner
else
    echo -e "${GREEN}✔ Git is already installed.${NC}"
fi

# Check and Install Yay
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}󰂖 Yay not found. Building from AUR...${NC}"
    sudo pacman -S --noconfirm --needed base-devel & spinner
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd - && rm -rf /tmp/yay
    echo -e "${GREEN}✔ Yay installed successfully.${NC}"
else
    echo -e "${GREEN}✔ Yay is already installed.${NC}"
fi

# --- START DEPLOYMENT ---

# 0. Core Dependencies
echo -e "\n${YELLOW}󰂖 [0/6] Installing Core Sync Tools (Yay)...${NC}"
SYNC_PACKS="wofi kvantum qt5ct qt6ct nwg-look xdg-desktop-portal-hyprland xdg-desktop-portal-gtk waybar swww nodejs bluez bluez-utils blueman"
(yay -S --noconfirm --needed $SYNC_PACKS) & spinner
echo -e "${GREEN}✔ Core packages ready.${NC}"

# 1. Clone Repository
echo -e "\n${YELLOW}󰇚 [1/6] Pulling Exocore Master Repository...${NC}"
REPO_URL="https://github.com/ChoruOfficial/Google-Pixel-Hyprland"
TEMP_DIR="/tmp/google-pixel-hyprland"
rm -rf $TEMP_DIR
(git clone $REPO_URL $TEMP_DIR) & spinner
echo -e "${GREEN}✔ Repository cloned to temp.${NC}"

# 2. Deploy Configs
echo -e "\n${YELLOW}󰆐 [2/6] Distributing modular configurations...${NC}"
(
    mkdir -p ~/.config
    cp -rf $TEMP_DIR/fish ~/.config/
    cp -rf $TEMP_DIR/hypr ~/.config/
    cp -rf $TEMP_DIR/kitty ~/.config/
    cp -rf $TEMP_DIR/waybar ~/.config/
) & spinner
echo -e "${GREEN}✔ Configs deployed to ~/.config/.${NC}"

# 3. Permissions & Execution
echo -e "\n${YELLOW}󰧿 [3/6] Setting system-wide permissions...${NC}"
(
    chmod +x ~/.config/waybar/scripts/*.js
    chmod +x ~/.config/waybar/install.sh
    chmod +x ~/.config/fish/install.sh
    chmod +x ~/.config/install.sh
) & spinner
echo -e "${GREEN}✔ Executables configured.${NC}"

# 4. Initialize Engines
echo -e "\n${YELLOW}󰈺 [4/6] Starting Shell & Waybar Engines...${NC}"
sudo systemctl enable --now bluetooth

# Execute Fish Installer if exists
if [ -f "$HOME/.config/fish/install.sh" ]; then
    bash "$HOME/.config/fish/install.sh"
fi

# Execute Waybar Installer if exists
if [ -f "$HOME/.config/waybar/install.sh" ]; then
    bash "$HOME/.config/waybar/install.sh"
fi
echo -e "${GREEN}✔ Sub-systems initialized.${NC}"

# 5. Additional Tools Installation
echo -e "\n${YELLOW}󰇚 [5/6] Installing additional tools (CMatrix, Cava, Peaclock, htop)...${NC}"
EXTRA_PACKS="cmatrix cava peaclock htop"
(yay -S --noconfirm --needed $EXTRA_PACKS) & spinner
echo -e "${GREEN}✔ Additional tools installed.${NC}"

# Deploy configs for cmatrix & cava if present
if [ -d "$TEMP_DIR/cmatrix" ]; then
    cp -rf $TEMP_DIR/cmatrix ~/.config/
    echo -e "${GREEN}✔ CMatrix config deployed.${NC}"
fi

if [ -d "$TEMP_DIR/cava" ]; then
    cp -rf $TEMP_DIR/cava ~/.config/
    echo -e "${GREEN}✔ Cava config deployed.${NC}"
fi

# Run installer scripts if exist
if [ -f "$HOME/.config/cmatrix/install.sh" ]; then
    bash "$HOME/.config/cmatrix/install.sh"
fi

if [ -f "$HOME/.config/cava/install.sh" ]; then
    bash "$HOME/.config/cava/install.sh"
fi

# Check and Install Fish Shell
if ! command -v fish &> /dev/null; then
    echo -e "${YELLOW}🐟 Fish shell not found. Installing via pacman...${NC}"
    sudo pacman -S --noconfirm fish & spinner
else
    echo -e "${GREEN}✔ Fish shell is already installed.${NC}"
fi

# 6. Cleanup
echo -e "\n${YELLOW}󱐋 [6/6] Finalizing deployment...${NC}"
rm -rf $TEMP_DIR
echo -e "${GREEN}✔ Temporary files cleared.${NC}"

# Final message
echo -e "\n${BLUE}==========================================================${NC}"
echo -e "${GREEN}   MASTER DEPLOYMENT FINISHED!${NC}"
echo -e "${G3}   Everything is set up. Check your Waybar and Shell.${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo -e "${PURPLE}   REBOOT is highly recommended.${NC}\n"
