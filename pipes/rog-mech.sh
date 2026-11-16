#!/usr/bin/env bash
# ROG Mech pipes.sh (Debian package pipes-sh). Like tty-clock it has no config
# file, only flags, and its colours are kitty's ANSI ones: 1 red #ff2233,
# 9 red_hi #ff5566, 7 subtext #a9b6c6 and 12 volt #b8d4ff.
# -t 0 is the plain box-drawing pipe set. Extra flags are passed through.
exec pipes.sh -t 0 -c 1 -c 9 -c 7 -c 12 -p 2 -f 75 -r 4000 -R "$@"
