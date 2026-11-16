#!/usr/bin/env bash
# Toggle a GTK month calendar popup under the bar clock.
# Arrows in the header navigate months/years; Escape or clicking elsewhere closes it.

CLASS="PolybarCalendar"
WIDTH=300
GAP=8
BAR_HEIGHT=30

# Second click on the clock closes the popup.
if pkill -f -- "--class=$CLASS"; then
    exit 0
fi

eval "$(xdotool getmouselocation --shell)"

# Clamp the popup inside the monitor the click came from.
read -r MON_X MON_Y MON_W < <(
    xrandr --listactivemonitors | awk -v mx="$X" -v my="$Y" '
        NR > 1 {
            split($3, g, /[\/x+]/)
            w = g[1]; h = g[3]; x = g[5]; y = g[6]
            if (mx >= x && mx < x + w && my >= y && my < y + h) { print x, y, w; exit }
        }'
)
MON_X=${MON_X:-0}
MON_Y=${MON_Y:-0}
MON_W=${MON_W:-1920}

POS_X=$((X - WIDTH / 2))
MAX_X=$((MON_X + MON_W - WIDTH - GAP))
((POS_X > MAX_X)) && POS_X=$MAX_X
((POS_X < MON_X + GAP)) && POS_X=$((MON_X + GAP))
POS_Y=$((MON_Y + BAR_HEIGHT + GAP))

GTK_THEME=Tokyonight-Dark yad --calendar \
    --class="$CLASS" --title="Calendar" \
    --width="$WIDTH" --posx="$POS_X" --posy="$POS_Y" \
    --undecorated --skip-taskbar --on-top --no-buttons \
    --close-on-unfocus --show-weeks \
    >/dev/null 2>&1 &
