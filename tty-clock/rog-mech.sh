#!/usr/bin/env bash
# ROG Mech tty-clock. tty-clock has no config file, only flags, so they live here.
# It can only pick from the 8 ANSI colours: -C 1 is kitty's color1, ROG red #ff2233.
# -x draws the box in the terminal foreground, chrome #d6dde6. Skip -b: it sets blink.
# Extra flags are passed through:  ~/.config/tty-clock/rog-mech.sh -S
exec tty-clock -c -s -x -C 1 -f '%a %d %b %Y' "$@"
