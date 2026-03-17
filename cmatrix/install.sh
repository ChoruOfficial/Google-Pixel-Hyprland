#!/bin/bash

# Colors for the installer
G1='\033[0;32m'
G2='\033[1;32m'
G3='\033[1;32m'
G4='\033[0;32m'
G5='\033[0;32m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

clear
echo -e "${G1}  ███████╗ ██╗  ██╗ ██████╗  ██████╗ ██████╗  ██████╗ ███████╗"
echo -e "${G2}  ██╔════ ╝╚██╗██╔╝██╔═══██╗██╔════╝ ██╔═══██╗██╔══██╗██╔════╝"
echo -e "${G3}  █████╗    ╚███╔╝ ██║   ██║██║      ██║   ██║██████╔╝█████╗  "
echo -e "${G4}  ██╔══╝    ██╔██╗ ██║   ██║██║      ██║   ██║██╔══██╗██╔══╝  "
echo -e "${G5}  ███████╗ ██╔╝ ██╗╚██████╔╝╚██████╗╚██████╔╝ ██║  ██║███████╗"
echo -e "${G5}  ╚══════╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝"
echo -e "            ${PURPLE}MASTER AUTO-DEPLOYMENT v2.2.0${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo -e "${NC}  AUTHOR: ${GREEN}Johnsteve Costanos (Choru Official)${NC}"
echo -e "${BLUE}==========================================================${NC}"

echo -e "\n${BLUE}[*]${NC} Creating directories..."
mkdir -p ~/.config/cmatrix
mkdir -p ~/.local/bin

# 2. Gagawa ng config file sa ~/.config/cmatrix/config
echo -e "${BLUE}[*]${NC} Writing config file..."
cat << 'EOF' > ~/.config/cmatrix/config
CMATRIX_ARGS="-ab -u 6 -C green"
EOF

# 3. Gagawa ng executable script sa ~/.config/cmatrix/matrix.sh
echo -e "${BLUE}[*]${NC} Writing execution script..."
cat << 'EOF' > ~/.config/cmatrix/matrix.sh
#!/bin/bash
source ~/.config/cmatrix/config

kitty --class cmatrix_window -e cmatrix $CMATRIX_ARGS
EOF

chmod +x ~/.config/cmatrix/matrix.sh

# 4. Gagawa ng symlink sa ~/.local/bin/matrix para matawag mo kahit saan
echo -e "${BLUE}[*]${NC} Linking to ~/.local/bin/matrix..."
ln -sf ~/.config/cmatrix/matrix.sh ~/.local/bin/matrix
chmod +x ~/.local/bin/matrix

echo -e "${GREEN}[+]${NC} Installation Complete! Subukan i-type ang: ${PURPLE}matrix${NC}"
