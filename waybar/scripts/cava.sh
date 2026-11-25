#!/usr/bin/env bash
# Streams cava's raw 0-7 bar levels to Waybar as block characters, one line per frame.
# uniq drops repeated frames, so the bars stop redrawing during silence.
#
# cava's "auto" input picks a silent device here (the Bluetooth headset's
# microphone), so it's pointed at the current output's monitor explicitly, and
# restarted when the default output changes (e.g. headphones to speakers).
base=$(dirname "$0")/../cava.conf
conf=${XDG_RUNTIME_DIR:-/tmp}/waybar-cava-$$.conf

trap 'kill "$cava" 2>/dev/null; rm -f "$conf"' EXIT
trap 'exit' TERM

while :; do
  sink=$(pactl get-default-sink)
  { cat "$base"; printf '\n[input]\nmethod = pulse\nsource = %s.monitor\n' "$sink"; } > "$conf"
  cava -p "$conf" > >(sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g' | stdbuf -oL uniq) &
  cava=$!
  # During silence nothing is written to Waybar, so SIGPIPE can't stop cava after
  # the bar exits; the EXIT trap does.
  while kill -0 "$cava" 2>/dev/null && [ "$(pactl get-default-sink)" = "$sink" ]; do
    sleep 2
  done
  kill "$cava" 2>/dev/null
  wait "$cava" 2>/dev/null
  sleep 1 # don't spin if cava keeps failing (e.g. the audio server restarting)
done
