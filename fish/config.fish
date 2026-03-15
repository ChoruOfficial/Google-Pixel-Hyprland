###########################################################
# PROJECT:  EXOCORE SHELL ENGINE (v1.9.1)
# AUTHOR:   Choru Official (Johnsteve Costanos)
###########################################################

if status is-interactive
    # 1. Path & State Setup
    set -l state_file "$HOME/.config/fish/theme_state"
    set -l anime_dir "$HOME/.config/fish/logo/anime"
    set -l exocore_logo "$HOME/.config/fish/logo/exocore/logo.png"

    # Auto-create state file if missing
    if not test -f $state_file
        echo "exocore" > $state_file
    end
    set -l current_mode (cat $state_file)

    # 2. Display Engine (Fastfetch)
    if test "$current_mode" = "anime"
        set -l random_logo (find $anime_dir -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) | shuf -n 1)
        if test -n "$random_logo"
            fastfetch --logo "$random_logo" --logo-type kitty --logo-width 35 --logo-height 15
        else
            fastfetch --logo "$exocore_logo" --logo-type kitty --logo-width 35 --logo-height 15
        end
    else
        fastfetch --logo "$exocore_logo" --logo-type kitty --logo-width 35 --logo-height 15
    end
end

# --- CUSTOM COMMANDS ---

function anime
    echo "anime" > ~/.config/fish/theme_state
    echo (set_color green)"󰄬 Anime Mode Active."(set_color normal)
    sleep 0.5; clear; exec fish
end

function exocore
    echo "exocore" > ~/.config/fish/theme_state
    echo (set_color blue)"󰄬 Normal Mode Active."(set_color normal)
    sleep 0.5; clear; exec fish
end

# --- PROMPT (root@user STYLE) ---
function fish_prompt
    set -l last_status $status
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -l blue (set_color -o blue)
    set -l green (set_color -o green)
    set -l red (set_color -o red)
    set -l white (set_color -o white)
    set -l normal (set_color normal)

    # Check if user is root
    set -l user_color $green
    if functions -q fish_is_root_user; and fish_is_root_user
        set user_color $red
    end

    # Line 1: user@hostname at path
    echo -n -s $blue "╭─ " $user_color $USER $white "@" $cyan (prompt_hostname) $normal " at " $green (prompt_pwd) $normal

    # Line 2: Prompt Arrow
    echo
    if test $last_status -eq 0
        echo -n -s $blue "╰─" $blue "❯ " $normal
    else
        echo -n -s $blue "╰─" $red "❯ " $normal
    end
end

# Remove default greeting
set -g fish_greeting ""
