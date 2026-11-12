#!/usr/bin/env bash
# Sets the wallpaper on every connected monitor, whatever the layout is.
# Uses the looping video (xwinwrap + mpv) when available, otherwise the
# static image with feh.

VIDEO="$HOME/Wallpapers/silver-surfer-cosmic-void.3840x2160.mp4"
IMAGE="$HOME/Wallpapers/gargantua-black-3840x2160-9621.jpg"

# i3 and the autorandr postswitch hook can run this at the same time: one at a
# time (players must not inherit the lock fd, see 9>&- below).
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/wallpaper.lock"
flock 9

# Restart cleanly so running it again (or after a monitor change) never stacks players.
pkill -x xwinwrap 2>/dev/null
while pgrep -x xwinwrap >/dev/null; do sleep 0.1; done

if [[ -f "$VIDEO" ]] && command -v xwinwrap >/dev/null && command -v mpv >/dev/null; then
    # One player per monitor, using its real geometry: WIDTHxHEIGHT+X+Y
    xrandr --query | awk '/ connected/' | grep -oE '[0-9]+x[0-9]+\+[0-9]+\+[0-9]+' |
        while read -r geometry; do
            xwinwrap -g "$geometry" -ov -- mpv -wid WID --no-audio --loop --no-osc \
                --no-osd-bar --no-input-default-bindings --hwdec=auto --panscan=1.0 \
                "$VIDEO" >/dev/null 2>&1 9>&- &
        done
elif [[ -f "$IMAGE" ]] && command -v feh >/dev/null; then
    feh --no-fehbg --bg-fill "$IMAGE"
fi
