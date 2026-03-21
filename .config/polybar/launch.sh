#!/usr/bin/env bash

# Matar cualquier instancia de Polybar que esté corriendo
killall -q polybar

# Esperar a que los procesos se cierren
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Lanzar la barra (el nombre "mi_barra" debe coincidir con el config.ini)
# Detectar monitores y lanzar una barra en cada uno
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload mi_barra &
  done
else
  polybar --reload mi_barra &
fi
