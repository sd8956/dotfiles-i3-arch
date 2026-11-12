#!/usr/bin/env bash

# i3 (exec_always) and the autorandr postswitch hook both run this at login.
# Run one at a time, or each kills the other's bars and both launch theirs
# (two bars per monitor). Bars must not inherit the lock fd (9>&-), or they
# would hold it forever and block the next run.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/polybar-launch.lock"
flock 9

# Matar cualquier instancia de Polybar que esté corriendo
killall -q polybar

# Esperar a que los procesos se cierren
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Tray icons can only fake transparency by copying the root pixmap. A video
# wallpaper (xwinwrap) leaves no root pixmap, so the icons get a black box.
# Set a solid one matching the bar tone, only when none exists, so a real
# feh wallpaper is never overwritten.
if ! xprop -root _XROOTPMAP_ID 2>/dev/null | grep -q 'pixmap id'; then
  feh --no-fehbg --bg-tile "$HOME/.config/polybar/tray-bg.ppm" 2>/dev/null
fi

# Lanzar la barra (el nombre "mi_barra" debe coincidir con el config.ini)
# Detectar monitores y lanzar una barra en cada uno
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload mi_barra 9>&- &
  done
else
  polybar --reload mi_barra 9>&- &
fi
