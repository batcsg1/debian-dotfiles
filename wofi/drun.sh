#!/usr/bin/env bash
# Opens the wofi app launcher. wofi resolves the stylesheet's @import against
# its working directory, not the config folder, so it's started from here.
cd "$(dirname "$(readlink -f "$0")")" && exec wofi --show drun "$@"
