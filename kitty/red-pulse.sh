#!/usr/bin/env bash
# Breathes kitty's cursor, active border and active tab through ROG reds.
# Run from inside kitty (uses $KITTY_LISTEN_ON):  ~/.config/kitty/red-pulse.sh &
colors=(6b0a12 a3101d d81a2a ff2233 ff5566 ff2233 d81a2a a3101d)
delay=${1:-0.15}
i=0
while :; do
  c=${colors[i % ${#colors[@]}]}
  kitten @ set-colors -a \
    cursor="#$c" active_border_color="#$c" active_tab_background="#$c" 2>/dev/null || exit 0
  i=$((i + 1))
  sleep "$delay"
done
