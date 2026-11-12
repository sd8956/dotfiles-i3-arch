#!/usr/bin/env bash
# macOS-style control center (rofi): Wi-Fi, Bluetooth, sound, Do Not Disturb, power.
# Toggles keep the menu open with the updated state; Esc closes it.

THEME="$HOME/.config/rofi/themes/control-center.rasi"

menu() {  # menu <title> <entries...>: prints the selected index, empty on Esc
    local title="$1"; shift
    printf '%s\n' "$@" | rofi -dmenu -i -format i -no-custom -p "󰍉" -mesg "$title" -theme "$THEME"
}

notify() { notify-send -a "Control Center" "$1" "${2:-}"; }

on_off() { [[ "$1" == "yes" ]] && echo "On" || echo "Off"; }

# ---------- state ----------
wifi_enabled() { [[ "$(nmcli -t -f WIFI radio 2>/dev/null)" == "enabled" ]]; }
wifi_ssid()    { nmcli -t -f ACTIVE,SSID device wifi 2>/dev/null | awk -F: '$1 == "yes" { print $2; exit }'; }
bt_powered()   { bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; }
volume()       { pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | grep -oE '[0-9]+%' | head -1; }
muted()        { pactl get-sink-mute @DEFAULT_SINK@ 2>/dev/null | grep -q yes; }
dnd_on()       { [[ "$(dunstctl is-paused 2>/dev/null)" == "true" ]]; }

# ---------- Wi-Fi ----------
wifi_menu() {
    if ! wifi_enabled; then
        [[ "$(menu "Wi-Fi: Off" "󰖩  Turn Wi-Fi On")" == "0" ]] && nmcli radio wifi on
        return
    fi

    # Networks first (strongest first, as nmcli lists them), toggles last:
    # Enter on the default row never turns Wi-Fi off by accident.
    local -a ssids=() rows=()
    local -A seen=()
    local in_use signal security ssid
    while IFS=: read -r in_use signal security ssid; do
        [[ -z "$ssid" || -n "${seen[$ssid]:-}" ]] && continue   # one row per network name
        seen[$ssid]=1
        ssids+=("$ssid")
        rows+=("$([[ "$in_use" == "*" ]] && echo "󰄬" || echo "󰤨")  $ssid  ${signal}%$([[ -n "$security" && "$security" != "--" ]] && echo "  󰌾")")
    done < <(nmcli -t -f IN-USE,SIGNAL,SECURITY,SSID device wifi list 2>/dev/null)
    local n=${#ssids[@]}
    rows+=("󰖪  Turn Wi-Fi Off" "󰒓  Network Settings…")

    local choice; choice=$(menu "Wi-Fi: $(wifi_ssid)" "${rows[@]}")
    [[ -z "$choice" ]] && return
    if (( choice < n )); then
        wifi_connect "${ssids[$choice]}"
    elif (( choice == n )); then
        nmcli radio wifi off
    else
        nm-connection-editor &
    fi
}

wifi_connect() {
    local ssid="$1" password
    if nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then
        nmcli connection up id "$ssid" >/dev/null 2>&1 && notify "Wi-Fi" "Connected to $ssid" && return
    fi
    if nmcli device wifi connect "$ssid" >/dev/null 2>&1; then
        notify "Wi-Fi" "Connected to $ssid"; return
    fi
    password=$(rofi -dmenu -password -p "Password for $ssid" -theme "$THEME" -lines 0) || return
    if nmcli device wifi connect "$ssid" password "$password" >/dev/null 2>&1; then
        notify "Wi-Fi" "Connected to $ssid"
    else
        notify "Wi-Fi" "Could not connect to $ssid"
    fi
}

# ---------- Bluetooth ----------
bt_menu() {
    if ! bt_powered; then
        local choice; choice=$(menu "Bluetooth: Off" "󰂯  Turn Bluetooth On" "󰒓  Bluetooth Settings…")
        case "$choice" in
            0) bluetoothctl power on >/dev/null ;;
            1) blueman-manager & ;;
        esac
        return
    fi

    # Paired devices first, toggles last (same reason as Wi-Fi).
    local -a macs=() rows=()
    local mac name
    while read -r _ mac name; do
        macs+=("$mac")
        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            rows+=("󰂱  $name  (connected)")
        else
            rows+=("󰂯  $name")
        fi
    done < <(bluetoothctl devices Paired 2>/dev/null)
    local n=${#macs[@]}
    rows+=("󰂲  Turn Bluetooth Off" "󰒓  Bluetooth Settings…")

    local choice; choice=$(menu "Bluetooth: On" "${rows[@]}")
    [[ -z "$choice" ]] && return
    if (( choice < n )); then
        mac="${macs[$choice]}"
        if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
            bluetoothctl disconnect "$mac" >/dev/null
        else
            bluetoothctl connect "$mac" >/dev/null || notify "Bluetooth" "Could not connect"
        fi
    elif (( choice == n )); then
        bluetoothctl power off >/dev/null
    else
        blueman-manager &
    fi
}

# ---------- Sound ----------
sound_menu() {
    local choice
    while true; do
        choice=$(menu "Sound: $(volume)$(muted && echo " (muted)")" \
            "󰝝  Volume +10%" "󰝞  Volume −10%" \
            "$(muted && echo "󰕾  Unmute" || echo "󰝟  Mute")" "󰒓  Sound Settings…")
        case "$choice" in
            0) pactl set-sink-volume @DEFAULT_SINK@ +10% ;;
            1) pactl set-sink-volume @DEFAULT_SINK@ -10% ;;
            2) pactl set-sink-mute @DEFAULT_SINK@ toggle ;;
            3) env GTK_THEME=Tokyonight-Dark pavucontrol & return ;;
            *) return ;;
        esac
    done
}

# ---------- main ----------
while true; do
    wifi_label="Off"; wifi_enabled && wifi_label="$(wifi_ssid)"; wifi_label="${wifi_label:-Not connected}"
    bt_label="Off"; bt_powered && bt_label="On"
    dnd_label="Off"; dnd_on && dnd_label="On"
    sound_label="$(volume)"; muted && sound_label="Muted"

    choice=$(menu "Control Center" \
        "󰖩  Wi-Fi  ·  $wifi_label" \
        "󰂯  Bluetooth  ·  $bt_label" \
        "󰕾  Sound  ·  $sound_label" \
        "󰂛  Do Not Disturb  ·  $dnd_label" \
        "󰐥  Power…")

    case "$choice" in
        0) wifi_menu ;;
        1) bt_menu ;;
        2) sound_menu ;;
        3) dunstctl set-paused toggle ;;
        4) exec "$HOME/.config/rofi/powermenu.sh" ;;
        *) exit 0 ;;
    esac
done
