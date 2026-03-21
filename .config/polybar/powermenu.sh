#!/bin/bash
opciones="Bloquear\nSuspender\nReiniciar\nApagar"

# Lanza Rofi y guarda la opción seleccionada
seleccion=$(echo -e "$opciones" | rofi -dmenu -i -p "Sistema" -theme ~/.config/rofi/themes/tokyonight_big1.rasi)

case $seleccion in
    Bloquear) i3lock -c 1a1b26 ;; # Usa el color de fondo de TokyoNight
    Suspender) systemctl suspend ;;
    Reiniciar) systemctl reboot ;;
    Apagar) systemctl poweroff ;;
esac
