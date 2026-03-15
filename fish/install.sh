#!/bin/bash

# ---------------------------------------------------------
# PROJECT:  EXOCORE FISH SHELL ENGINE
# AUTHOR:   Choru Official (Johnsteve Costanos)
# VERSION:  1.8.5 (Premium Edition)
# ---------------------------------------------------------

# Color variables (Gradient Palette)
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
echo -e "           ${PURPLE}EXOCORE FISH ENGINE DEPLOYMENT${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo -e "${NC}  AUTHOR: ${GREEN}Johnsteve Costanos (Choru Official)${NC}"
echo -e "${BLUE}==========================================================${NC}"

# 1. Directory Structure
echo -e "\n${YELLOW}󰉖 [1/4] Initializing Fish structure...${NC}"
(
    mkdir -p ~/.config/fish/logo/anime
    mkdir -p ~/.config/fish/logo/exocore
    echo "exocore" > ~/.config/fish/theme_state
) & spinner
echo -e "${GREEN}✔ Directories ready. Default: EXOCORE mode.${NC}"

# 2. Dependencies Check
echo -e "\n${YELLOW}󰂖 [2/4] Verifying system dependencies...${NC}"
(sudo pacman -S --noconfirm --needed fastfetch imagemagick findutils) & spinner
echo -e "${GREEN}✔ Dependencies installed.${NC}"

# 3. Config Injection
echo -e "\n${YELLOW}󱧿 [3/4] Injecting Exocore Fish Configuration...${NC}"
cat << 'EOF' > ~/.config/fish/config.fish
# ---------------------------------------------------------
# PROJECT:  EXOCORE SHELL ENGINE (v1.8.5)
# AUTHOR:   Choru Official (Johnsteve Costanos)
# ---------------------------------------------------------

if status is-interactive
    set -l state_file "$HOME/.config/fish/theme_state"
    set -l anime_dir "$HOME/.config/fish/logo/anime"
    set -l exocore_logo "$HOME/.config/fish/logo/exocore/logo.jpg"

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

# --- PROMPT (Exocore@User Format) ---
function fish_prompt
    set -l last_status $status
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l blue (set_color -o blue)
    set -l green (set_color -o green)
    set -l red (set_color -o red)
    set -l normal (set_color normal)

    echo -n -s $blue "╭─ " $cyan "󰣇 " $yellow "Exocore@$USER" $normal " at " $green (prompt_pwd) $normal
    echo
    if test $last_status -eq 0
        echo -n -s $blue "╰─" $blue "❯ " $normal
    else
        echo -n -s $blue "╰─" $red "❯ " $normal
    end
end

set -g fish_greeting ""
EOF
echo -e "${GREEN}✔ config.fish updated with Exocore@User prompt.${NC}"

# 4. Finalization
echo -e "\n${BLUE}==========================================================${NC}"
echo -e "${GREEN}   FISH INSTALLATION COMPLETE!${NC}"
echo -e "${G3}   Current Prompt: Exocore@$USER${NC}"
echo -e "${BLUE}==========================================================${NC}"
echo -e "${PURPLE}   Restarting shell...${NC}\n"

sleep 1
exec fish
