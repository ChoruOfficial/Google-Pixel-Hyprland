###########################################################
# PROJECT:  EXOCORE SHELL ENGINE (v1.8)
# AUTHOR:   Choru Official (Johnsteve Costanos)
###########################################################

if status is-interactive
    set -l state_file "$HOME/.config/fish/theme_state"
    set -l anime_dir "$HOME/.config/fish/logo/anime"
    set -l exocore_logo "$HOME/.config/fish/logo/exocore/logo.jpg"

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
        # NORMAL MODE (Exocore) - Gagana na ito dahil tama na ang file extension
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
# In-update para sa Exocore@user format
function fish_prompt
    set -l last_status $status
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l blue (set_color -o blue)
    set -l green (set_color -o green)
    set -l red (set_color -o red)
    set -l normal (set_color normal)

    # Ginagamit ang $USER variable para makuha ang pangalan mo
    echo -n -s $blue "╭─ " $cyan "󰣇 " $yellow "Exocore@$USER" $normal " at " $green (prompt_pwd) $normal
    echo
    if test $last_status -eq 0
        echo -n -s $blue "╰─" $blue "❯ " $normal
    else
        echo -n -s $blue "╰─" $red "❯ " $normal
    end
end

set -g fish_greeting ""
