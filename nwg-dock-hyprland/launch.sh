#!/usr/bin/env bash
# Starts one ROG Mech dock at the bottom of every monitor (Hyprland autostart).
# Without -o the dock only opens on the focused monitor, so each output gets
# its own instance; -m skips the single-instance lock that would stop the rest.
dir=$(dirname "$(readlink -f "$0")")
pkill -x nwg-dock-hyprla # process names are cut to 15 characters

for output in $(hyprctl monitors -j | jq -r '.[].name'); do
  nwg-dock-hyprland -m -o "$output" -p bottom -x -i 32 -c "wofi --show drun" -ico "$dir/rog.svg" "$@" &
done
