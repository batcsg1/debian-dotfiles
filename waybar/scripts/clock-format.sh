#!/usr/bin/env bash
# The 12h/24h switch on the clock pill. With no argument it prints the switch's
# label; "toggle" flips the saved choice, which clock.py reads every second.
state=${XDG_CACHE_HOME:-$HOME/.cache}/waybar-clock-format
current=$(cat "$state" 2>/dev/null || echo 12)

if [ "$1" = toggle ]; then
  [ "$current" = 24 ] && current=12 || current=24
  echo "$current" > "$state"
  # redraw the switch only once the new choice is saved (signal 8 in config.jsonc);
  # Waybar's own refresh after a click can read the old one
  pkill -RTMIN+8 -x waybar
  exit
fi

echo "{\"text\":\"${current}h\",\"class\":\"h${current}\",\"tooltip\":\"Click to switch to $([ "$current" = 24 ] && echo 12 || echo 24)-hour time\"}"
