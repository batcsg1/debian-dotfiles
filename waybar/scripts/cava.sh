#!/usr/bin/env bash
# Streams cava's raw 0-7 bar levels to Waybar as block characters, one line per frame.
# uniq drops repeated frames, so the bars stop redrawing during silence.
conf=$(dirname "$0")/../cava.conf
cava -p "$conf" | sed -u 's/;//g;s/0/▁/g;s/1/▂/g;s/2/▃/g;s/3/▄/g;s/4/▅/g;s/5/▆/g;s/6/▇/g;s/7/█/g' | stdbuf -oL uniq
