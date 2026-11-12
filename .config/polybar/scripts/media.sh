#!/usr/bin/env bash
# Polybar "now playing" module (tail = true): artist — title with
# previous / play-pause / next buttons. Prefers Spotify, falls back to any
# MPRIS player. Prints an empty line (module hidden) when nothing plays.

MAX_CHARS=45
PLAYERS="spotify,%any"

if ! command -v playerctl >/dev/null; then
    echo ""
    exec sleep infinity   # Keep polybar from respawning the script in a loop
fi

render() {
    local player="$1" status="$2" artist="$3" title="$4" text toggle icon
    if [[ -z "$status" || "$status" == "Stopped" || -z "$title" ]]; then
        echo ""
        return
    fi

    text="$title"
    [[ -n "$artist" ]] && text="$artist — $title"
    (( ${#text} > MAX_CHARS )) && text="${text:0:MAX_CHARS-1}…"
    text="${text//%/%%}"   # A literal % would start a polybar format tag

    toggle="󰐊"
    [[ "$status" == "Playing" ]] && toggle="󰏤"

    icon="%{F#7aa2f7}󰝚%{F-}"                          # Any MPRIS player
    [[ "$player" == spotify* ]] && icon="%{F#1db954}󰓇%{F-}"  # Spotify green logo

    echo "$icon  $text   %{A1:playerctl -p $player previous:}󰒮%{A}  %{A1:playerctl -p $player play-pause:}$toggle%{A}  %{A1:playerctl -p $player next:}󰒭%{A}"
}

# One line per change (track, status, player opened/closed). Fields use the
# ASCII unit separator: a tab is IFS whitespace and would merge empty fields.
# Buttons target the exact player shown, not the "spotify,%any" selector.
playerctl -p "$PLAYERS" --follow metadata \
    --format $'{{playerName}}\x1f{{status}}\x1f{{artist}}\x1f{{title}}' 2>/dev/null |
    while IFS=$'\x1f' read -r player status artist title; do
        render "$player" "$status" "$artist" "$title"
    done
