#!/usr/bin/env bash
# macOS-style "maximize" toggle for the focused window.
# The window floats above the tiled ones and fills the workspace, keeping the
# bar and dock visible (unlike `fullscreen`). Run it again to restore it.
#
# Tiled windows get back to their exact slot: while maximized, an invisible
# placeholder window keeps that slot in the layout, and restoring swaps the
# window with it. Without it, i3 would re-tile the window wherever focus is.
set -euo pipefail

GAP="${MAXIMIZE_GAP:-12}"
PLACEHOLDER_CLASS="MaxPlaceholder"

tree=$(i3-msg -t get_tree)
node=$(jq -c 'first(recurse(.nodes[]?, .floating_nodes[]?) | select(.focused and .window != null))' <<<"$tree")
[[ -z "$node" ]] && exit 0

id=$(jq -r '.id' <<<"$node")
win=$(jq -r '.window' <<<"$node")
mark=$(jq -r '[.marks[]? | select(startswith("_max_"))][0] // empty' <<<"$node")
slot_mark="_maxslot_${id}"

# Restore: a tiled window goes back to the slot its placeholder kept.
if [[ "$mark" == _max_tiled_* ]]; then
  if i3-msg -t get_marks | jq -e --arg m "$slot_mark" 'index($m) != null' >/dev/null; then
    i3-msg -q "[con_id=$id] unmark $mark, floating disable, swap container with mark $slot_mark"
    i3-msg -q "[con_mark=\"^${slot_mark}\$\"] kill"
  else
    i3-msg -q "[con_id=$id] unmark $mark, floating disable"
  fi
  i3-msg -q "[con_id=$id] focus"
  exit 0
fi

# Restore: a floating window goes back to its saved geometry.
if [[ "$mark" == _max_float_* ]]; then
  IFS=_ read -r _ _ _ _ x y w h <<<"$mark"
  i3-msg -q "[con_id=$id] unmark $mark, resize set $w px $h px, move position $x px $y px"
  exit 0
fi

# Maximize.
is_floating=$(jq --argjson id "$id" \
  'any(.. | objects | .floating_nodes[]? | recurse(.nodes[]?); .id == $id)' <<<"$tree")

read -r wx wy ww wh < <(i3-msg -t get_workspaces |
  jq -r '.[] | select(.focused) | "\(.rect.x) \(.rect.y) \(.rect.width) \(.rect.height)"')
geometry="resize set $((ww - 2 * GAP)) px $((wh - 2 * GAP)) px, move position $((wx + GAP)) px $((wy + GAP)) px"

if [[ "$is_floating" == "true" ]]; then
  saved=$(jq -r '.rect | "\(.x)_\(.y)_\(.width)_\(.height)"' <<<"$node")
  i3-msg -q "[con_id=$id] mark --add _max_float_${id}_${saved}, $geometry"
  exit 0
fi

# Tiled: open the placeholder right next to the window (i3 places new windows
# after the focused one). It closes itself if the maximized window is closed.
title="maxslot-${id}"
(
  yad --title="$title" --class="$PLACEHOLDER_CLASS" --no-buttons --undecorated \
    --skip-taskbar --borders=0 --text="" >/dev/null 2>&1 &
  ypid=$!
  while kill -0 "$ypid" 2>/dev/null && xprop -id "$win" >/dev/null 2>&1; do sleep 2; done
  kill "$ypid" 2>/dev/null
) >/dev/null 2>&1 &
disown

placeholder=""
for _ in $(seq 60); do
  placeholder=$(i3-msg -t get_tree |
    jq -r --arg t "$title" 'first(.. | objects | select(.name? == $t and .window != null) | .id) // empty')
  [[ -n "$placeholder" ]] && break
  sleep 0.05
done

if [[ -n "$placeholder" ]]; then
  i3-msg -q "[con_id=$placeholder] mark --add $slot_mark"
fi
i3-msg -q "[con_id=$id] focus, floating enable, mark --add _max_tiled_${id}, $geometry"
