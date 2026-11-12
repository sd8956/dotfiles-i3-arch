#!/usr/bin/env bash
# Prints the name of the focused application, like the macOS menu bar.
# Polybar runs it with `tail = true`: one line per focus change.

pretty_name() {
  local class="$1"
  class="${class##*.}"          # com.mitchellh.ghostty -> ghostty
  class="${class//[-_]/ }"      # google-chrome -> google chrome
  echo "${class^}"              # ghostty -> Ghostty
}

print_app() {
  local id class
  id=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | awk '{print $NF}')
  if [[ ! "$id" =~ ^0x[0-9a-fA-F]+$ || "$id" == "0x0" ]]; then
    echo "Desktop"
    return
  fi
  # WM_CLASS = "instance", "Class": keep the class.
  class=$(xprop -id "$id" WM_CLASS 2>/dev/null | awk -F'"' '{print $4}')
  if [[ -z "$class" ]]; then
    echo "Desktop"
  else
    pretty_name "$class"
  fi
}

print_app
xprop -spy -root _NET_ACTIVE_WINDOW 2>/dev/null | while read -r _; do
  print_app
done
