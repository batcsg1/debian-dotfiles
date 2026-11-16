#!/usr/bin/env bash
# ROG Mech pipes (Debian package pipes-sh, installed as /usr/games/pipes). Like
# tty-clock it has no config file, only flags, and it only accepts ANSI colours
# 0-7, which come from kitty: 1 red #ff2233, 7 subtext #a9b6c6, 4 volt_dim #6f93c4.
# -t 0 is the plain box-drawing pipe set. Extra flags are passed through.
exec pipes -t 0 -c 1 -c 7 -c 4 -p 2 -f 75 -r 4000 -R "$@"
