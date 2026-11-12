#!/usr/bin/env bash
# Clipboard history (greenclip) with the Spotlight look. Enter / one click puts
# the entry back into the clipboard.
#
# A script instead of an inline i3 binding: i3 splits commands on ';', even
# inside exec, which broke the -theme-str below.

exec rofi -modi "clipboard:greenclip print" -show clipboard -run-command '{cmd}' \
    -display-clipboard "󰅇" \
    -hover-select -me-select-entry MouseSecondary -me-accept-entry '!MousePrimary' \
    -theme "$HOME/.config/rofi/themes/spotlight.rasi" \
    -theme-str 'entry { placeholder: "Clipboard History"; }'
