#!/usr/bin/env bash
# Shows the lock screen avatar on the LightDM login screen too.
# Copies ~/.face (or the avatar made by lockscreen-setup.sh) to AccountsService,
# which slick-greeter reads. Asks for sudo. Safe to run again.
set -euo pipefail

ACCOUNTS_DIR="${ACCOUNTS_DIR:-/var/lib/AccountsService}"
src="$HOME/.face"
[[ -f "$src" ]] || src="${XDG_CACHE_HOME:-$HOME/.cache}/betterlockscreen/avatar.png"
[[ -f "$src" ]] || { echo "No avatar: run lockscreen-setup.sh first (or add ~/.face)." >&2; exit 1; }

icon="$ACCOUNTS_DIR/icons/$USER"
users="$ACCOUNTS_DIR/users/$USER"

sudo install -Dm644 "$src" "$icon"

if ! sudo test -f "$users"; then
    printf '[User]\nIcon=%s\n' "$icon" | sudo install -Dm600 /dev/stdin "$users"
elif sudo grep -q '^Icon=' "$users"; then
    sudo sed -i "s|^Icon=.*|Icon=$icon|" "$users"
elif sudo grep -q '^\[User\]' "$users"; then
    sudo sed -i "/^\[User\]/a Icon=$icon" "$users"
else
    printf '\n[User]\nIcon=%s\n' "$icon" | sudo tee -a "$users" >/dev/null
fi

echo "Login avatar set from $src"
