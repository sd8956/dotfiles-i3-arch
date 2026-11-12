#!/usr/bin/env bash
# macOS-style screenshots: save to ~/Pictures/Screenshots, copy to the clipboard
# and show a notification with a thumbnail (click it to open the image).
#
# Usage: screenshot.sh region|screen|window
#   region  drag to select an area (Esc cancels)
#   screen  the monitor under the mouse pointer
#   window  the focused window

set -uo pipefail

mode="${1:-region}"

pictures="$(xdg-user-dir PICTURES 2>/dev/null)"
[[ -z "$pictures" || "$pictures" == "$HOME" ]] && pictures="$HOME/Pictures"
dir="${SCREENSHOT_DIR:-$pictures/Screenshots}"
mkdir -p "$dir"
base="$dir/Screenshot $(date '+%Y-%m-%d at %H.%M.%S')"
file="$base.png"
n=2
while [[ -e "$file" ]]; do   # Two shots in the same second: "... (2).png", like macOS
    file="$base ($n).png"
    n=$((n + 1))
done

monitor_under_pointer() {  # prints WIDTHxHEIGHT+X+Y of the monitor with the pointer
    local px py
    eval "$(xdotool getmouselocation --shell)"
    px=$X; py=$Y
    xrandr --query | grep -oE ' connected( primary)? [0-9]+x[0-9]+\+[0-9]+\+[0-9]+' |
        grep -oE '[0-9]+x[0-9]+\+[0-9]+\+[0-9]+' |
        while IFS='x+' read -r w h x y; do
            if (( px >= x && px < x + w && py >= y && py < y + h )); then
                echo "${w}x${h}+${x}+${y}"
                break
            fi
        done
}

case "$mode" in
    region)
        # Selection drawn in TokyoNight blue; Esc or right click cancels (no file).
        maim --select --hidecursor --bordersize=2 --color=0.48,0.64,0.97,0.9 \
            --tolerance=2 "$file" || exit 0
        ;;
    screen)
        geometry="$(monitor_under_pointer)"
        maim --hidecursor ${geometry:+--geometry="$geometry"} "$file" || exit 1
        ;;
    window)
        maim --hidecursor --window="$(xdotool getactivewindow)" "$file" || exit 1
        ;;
    *)
        echo "Usage: $0 region|screen|window" >&2
        exit 2
        ;;
esac

xclip -selection clipboard -t image/png -i "$file"

# Runs in the background: notify-send waits for the click when an action is set.
(
    action=$(notify-send -a Screenshot -i "$file" -A open=Open \
        "Screenshot" "$(basename "$file")")
    [[ "$action" == "open" ]] && xdg-open "$file"
) >/dev/null 2>&1 &
disown
