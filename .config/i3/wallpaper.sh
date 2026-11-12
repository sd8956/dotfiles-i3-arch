#!/usr/bin/env bash
# Sets the wallpaper on every connected monitor, whatever the layout is.
# Uses the looping video (xwinwrap + mpv) when available, otherwise the
# static image with feh.

VIDEO="$HOME/Wallpapers/silver-surfer-cosmic-void.3840x2160.mp4"
IMAGE="$HOME/Wallpapers/gargantua-black-3840x2160-9621.jpg"

# Restart cleanly so running it again (or after a monitor change) never stacks players.
pkill -x xwinwrap 2>/dev/null

if [[ -f "$VIDEO" ]] && command -v xwinwrap >/dev/null && command -v mpv >/dev/null; then
    # One player per monitor, using its real geometry: WIDTHxHEIGHT+X+Y
    xrandr --query | awk '/ connected/' | grep -oE '[0-9]+x[0-9]+\+[0-9]+\+[0-9]+' |
        while read -r geometry; do
            xwinwrap -g "$geometry" -ov -- mpv -wid WID --no-audio --loop --no-osc \
                --no-osd-bar --no-input-default-bindings --hwdec=auto --panscan=1.0 \
                "$VIDEO" >/dev/null 2>&1 &
        done
elif [[ -f "$IMAGE" ]] && command -v feh >/dev/null; then
    feh --no-fehbg --bg-fill "$IMAGE"
fi
