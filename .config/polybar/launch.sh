#!/usr/bin/env bash

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
    MONITOR=$m polybar --reload mi_barra &
  done
else
  polybar --reload mi_barra &
fi
