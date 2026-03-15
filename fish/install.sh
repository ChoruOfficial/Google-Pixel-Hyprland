#!/bin/bash

###########################################################
# PROJECT:  EXOCORE FISH SHELL INSTALLER
# AUTHOR:   Choru Official (Johnsteve Costanos)
# DEFAULT:  Exocore Mode (Normal)
###########################################################

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}======================================================${NC}"
echo -e "${GREEN}       EXOCORE FISH ENGINE DEPLOYMENT v1.8           ${NC}"
echo -e "${BLUE}======================================================${NC}"

# 1. Create Directories
echo -e "\n${YELLOW}[1/4] Creating Logo Directories...${NC}"
mkdir -p ~/.config/fish/logo/anime
mkdir -p ~/.config/fish/logo/exocore

# SET DEFAULT TO EXOCORE (Para normal muna ang lahat)
echo "exocore" > ~/.config/fish/theme_state
echo -e "${GREEN}✔ Directories ready. Default mode set to: EXOCORE${NC}"

# 2. Check for Dependencies
echo -e "\n${YELLOW}[2/4] Checking Dependencies...${NC}"
sudo pacman -S --noconfirm --needed fastfetch imagemagick findutils

# 3. Write config.fish
echo -e "\n${YELLOW}[3/4] Injecting Exocore Fish Configuration...${NC}"

cat << 'EOF' > ~/.config/fish/config.fish
###########################################################
# PROJECT:  EXOCORE SHELL ENGINE (v1.8)
# AUTHOR:   Choru Official (Johnsteve Costanos)
###########################################################

if status is-interactive
    set -l state_file "$HOME/.config/fish/theme_state"
    set -l anime_dir "$HOME/.config/fish/logo/anime"
    set -l exocore_logo "$HOME/.config/fish/logo/exocore/logo.png"

    # Auto-create state file if missing
    if not test -f $state_file
        echo "exocore" > $state_file
    end
    set -l current_mode (cat $state_file)

    # Engine Logic
    if test "$current_mode" = "anime"
        set -l random_logo (find $anime_dir -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | shuf -n 1)

        if test -n "$random_logo"
            fastfetch --logo "$random_logo" --logo-type kitty --logo-width 35 --logo-height 15
        else
            fastfetch --logo "$exocore_logo" --logo-type kitty --logo-width 35 --logo-height 15
        end
    else
        # NORMAL MODE (Exocore)
        fastfetch --logo "$exocore_logo" --logo-type kitty --logo-width 35 --logo-height 15
    end
end

# --- COMMANDS ---

function anime
    echo "anime" > ~/.config/fish/theme_state
    echo (set_color green)"󰄬 Anime Mode Active. (Random Images)"(set_color normal)
    sleep 0.5; clear; exec fish
end

function exocore
    echo "exocore" > ~/.config/fish/theme_state
    echo (set_color blue)"󰄬 Normal Mode Active. (Exocore Service Logo)"(set_color normal)
    sleep 0.5; clear; exec fish
end

# --- PROMPT ---
function fish_prompt
    set -l last_status $status
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l blue (set_color -o blue)
    set -l green (set_color -o green)
    set -l red (set_color -o red)
    set -l normal (set_color normal)

    echo -n -s $blue "╭─ " $cyan "󰣇 " $yellow "Exocore" $normal " at " $green (prompt_pwd) $normal
    echo
    if test $last_status -eq 0
        echo -n -s $blue "╰─" $blue "❯ " $normal
    else
        echo -n -s $blue "╰─" $red "❯ " $normal
    end
end

set -g fish_greeting ""
EOF

echo -e "${GREEN}✔ config.fish updated.${NC}"

# 4. Success Message
echo -e "\n${BLUE}======================================================${NC}"
echo -e "${GREEN}   INSTALLATION COMPLETE!${NC}"
echo -e "${CYAN}   Default: Normal Mode (Exocore)${NC}"
echo -e "${CYAN}   Command 'anime' to switch to anime mode.${NC}"
echo -e "${CYAN}   Command 'exocore' to return to normal.${NC}"
echo -e "${BLUE}======================================================${NC}"

exec fish
