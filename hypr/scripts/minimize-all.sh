#!/usr/bin/env bash
# Minimise every window on every workspace, or bring them all back (SUPER + D).
# Hyprland has no minimise, so windows are tucked into the hidden workspace
# special:minimized; where each one came from is remembered so it can go back.
# Windows already in a special workspace (e.g. the SUPER + S scratchpad) are left alone.
state=${XDG_RUNTIME_DIR:-/tmp}/hypr-minimized.json
clients=$(hyprctl clients -j)

move() { # address workspace
  hyprctl dispatch "hl.dsp.window.move({ workspace = \"$2\", window = \"address:$1\", follow = false })" >/dev/null
}

hidden=$(jq -r '.[] | select(.workspace.name == "special:minimized") | .address' <<< "$clients")

if [ -n "$hidden" ]; then
  # restore: back to its own workspace, or the current one if it wasn't recorded
  current=$(hyprctl activeworkspace -j | jq -r .name)
  for addr in $hidden; do
    ws=$(jq -r --arg a "$addr" '.[$a] // empty' "$state" 2>/dev/null)
    move "$addr" "${ws:-$current}"
  done
  rm -f "$state"
else
  jq '[.[] | select(.workspace.name | startswith("special:") | not) | {(.address): .workspace.name}] | add // {}' \
    <<< "$clients" > "$state"
  for addr in $(jq -r 'keys[]' "$state"); do
    move "$addr" special:minimized
  done
fi
