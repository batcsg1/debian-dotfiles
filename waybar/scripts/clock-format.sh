#!/usr/bin/env bash
# The 12h/24h switch on the clock pill. "toggle" flips the saved choice, which
# clock.py reads every second; either way it prints the switch's label.
state=${XDG_CACHE_HOME:-$HOME/.cache}/waybar-clock-format
current=$(cat "$state" 2>/dev/null || echo 12)

if [ "$1" = toggle ]; then
  [ "$current" = 24 ] && current=12 || current=24
  echo "$current" > "$state"
fi

echo "{\"text\":\"${current}h\",\"class\":\"h${current}\",\"tooltip\":\"Click to switch to $([ "$current" = 24 ] && echo 12 || echo 24)-hour time\"}"
