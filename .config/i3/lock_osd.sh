#!/usr/bin/env bash

sleep 0.1 

# Matar el popup anterior si presionas la tecla muy rápido
pkill -f osd_ui.py 2>/dev/null

show_osd() {
    local icon=$1
    local color=$2
    # Ejecutar el script de Python en segundo plano
    python ~/.config/i3/osd_ui.py "$icon" "$color" &
}

if [ "$1" == "caps" ]; then
    if xset -q | grep -q "Caps Lock:\s*on"; then
        show_osd "" "#f7768e" # Rojo
    else
        show_osd "" "#9ece6a" # Verde
    fi
elif [ "$1" == "num" ]; then
    if xset -q | grep -q "Num Lock:\s*on"; then
        show_osd "󰎠" "#7aa2f7" # Azul
    else
        show_osd "󰎧" "#565f89" # Gris
    fi
fi
