#!/usr/bin/env bash
# Prepares the macOS-style lock screen.
#
# 1. betterlockscreen caches the blurred wallpaper (wall_blur.png).
# 2. The avatar (~/.face, or the user's initial) and an "Enter Password" field
#    are drawn on the monitor where i3lock shows the clock (display_on in
#    betterlockscreenrc), at the positions the rc gives the typing ring.
#
# Usage: lockscreen-setup.sh [wallpaper]   Re-cache from a wallpaper and draw
#        lockscreen-setup.sh --redraw      Only redraw on the existing cache
#
# It also leaves the square avatar in ~/.cache/betterlockscreen/avatar.png for
# the login screen (see install_setup.sh).
set -euo pipefail

RC="$HOME/.config/betterlockscreen/betterlockscreenrc"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/betterlockscreen/current"
BLUR="$CACHE/wall_blur.png"
BASE="$CACHE/wall_blur.base.png"       # Clean copy, so redraws never stack
DEFAULT_WALLPAPER="$HOME/Wallpapers/gargantua-black-3840x2160-9621.jpg"
FONT="Adwaita-Sans"
FONT_BOLD="Adwaita-Sans-Bold"

# Layout values shared with the rc (avatar center and radius, monitor index).
display_on=0; locktext="$USER"; LOCK_AVATAR_Y=0.70; LOCK_RADIUS=46
# shellcheck source=/dev/null
source "$RC"

if [[ "${1:-}" != "--redraw" ]]; then
    betterlockscreen -u "${1:-$DEFAULT_WALLPAPER}" --blur 0.5
    cp "$BLUR" "$BASE"
fi
[[ -f "$BASE" ]] || { echo "No cache yet: run without --redraw first." >&2; exit 1; }

# Geometry of the lock monitor: " 0: +*DP-0 1920/540x1080/310+0+0  DP-0"
read -r mw mh mx my < <(xrandr --listmonitors |
    awk -v n="$((display_on + 2))" 'NR == n { print $3 }' |
    sed -E 's|^([0-9]+)/[0-9]+x([0-9]+)/[0-9]+\+([0-9]+)\+([0-9]+)$|\1 \2 \3 \4|')
[[ -n "${mh:-}" ]] || { echo "Monitor $display_on not found." >&2; exit 1; }

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

size=$((LOCK_RADIUS * 2))
cx=$((mx + mw / 2))
cy=$(awk -v y="$my" -v h="$mh" -v f="$LOCK_AVATAR_Y" 'BEGIN { printf "%d", y + h * f }')

# --- Avatar: ~/.face cropped to a circle, or the initial on a gradient ---
if [[ -f "$HOME/.face" ]]; then
    magick "$HOME/.face" -resize "${size}x${size}^" -gravity center -extent "${size}x${size}" \
        "$work/face.png"
else
    initial="$(printf '%s' "$locktext" | cut -c1 | tr '[:lower:]' '[:upper:]')"
    magick -size "${size}x${size}" gradient:'#7aa2f7-#bb9af7' \
        -font "$FONT_BOLD" -pointsize $((size * 45 / 100)) -fill white \
        -gravity center -annotate +0+0 "$initial" "$work/face.png"
fi
magick "$work/face.png" \
    \( -size "${size}x${size}" xc:none -fill white \
       -draw "circle $((size / 2 - 1)),$((size / 2 - 1)) $((size / 2 - 1)),0" \) \
    -alpha set -compose DstIn -composite "$work/avatar.png"

# Square avatar for the login screen (LightDM reads it via AccountsService).
cp "$work/face.png" "$CACHE/../avatar.png"

# --- "Enter Password" field (rounded, translucent), under the name ---
fw=220; fh=34
magick -size "${fw}x${fh}" xc:none -fill '#ffffff2e' -stroke '#ffffff40' \
    -draw "roundrectangle 0,0 $((fw - 1)),$((fh - 1)) 17,17" \
    -font "$FONT" -pointsize 13 -fill '#ffffffa6' -stroke none \
    -gravity center -annotate +0+0 "Enter Password" "$work/field.png"

field_top=$((cy + LOCK_RADIUS + 58))
# Dim the wallpaper a bit (like macOS) so the white clock stays readable.
magick "$BASE" -fill black -colorize 28% \
    "$work/avatar.png" -geometry "+$((cx - LOCK_RADIUS))+$((cy - LOCK_RADIUS))" -composite \
    "$work/field.png" -geometry "+$((cx - fw / 2))+$field_top" -composite \
    "$BLUR"

echo "Lock screen ready: avatar at ${cx},${cy} on monitor $display_on (${mw}x${mh}+${mx}+${my})."
