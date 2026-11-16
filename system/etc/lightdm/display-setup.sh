#!/bin/sh
# Runs as root before the LightDM greeter starts, so the login screen uses the
# same monitor layout as the i3 session (autorandr profile "escritorio"):
# DP-0 on the left (primary), DP-2 on its right.
# Always exit 0: a failing display-setup-script makes LightDM abort the seat.

connected() {
    xrandr --query | grep -q "^$1 connected"
}

if connected DP-0 && connected DP-2; then
    xrandr --output DP-0 --mode 1920x1080 --rate 60 --pos 0x0 --primary \
           --output DP-2 --mode 1920x1080 --rate 60 --pos 1920x0 || true
fi

exit 0
