}#!/usr/bin/env bash

# Opciones con iconos Nerd Fonts
shutdown=""
reboot=""
lock=""
suspend=""
logout="󰍃"

options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | rofi -dmenu -i -p "" -theme ~/.config/rofi/themes/powermenu.rasi -me-select-entry 'MouseSecondary' -me-accept-entry 'MousePrimary' -hover-select)"

case $chosen in
    $shutdown) systemctl poweroff ;;
    $reboot) systemctl reboot ;;
    $lock) betterlockscreen -l blur ;; # O tu script de bloqueo
    $suspend) ~/.config/i3/sleep_lock.sh ;;
    $logout) i3-msg exit ;;
esac
