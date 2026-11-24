#!/usr/bin/env bash
# Applies the ROG Mech palette to the motherboard's Aura RGB, then saves it
# as the OpenRGB profile "rog-mech" so hyprland can load it with `openrgb -p rog-mech`.
#   rog-mech.sh [static|accent|breathe|off]
# Colours follow waybar/colors.css (red #ff2233, red_deep #6b0a12, volt #b8d4ff),
# minus the green and blue in the reds: LEDs have no gamma, so the little blue in
# #ff2233 that a screen hides turns the LEDs pink.
set -euo pipefail

red=FF0000
red_deep=6B0000
volt=B8D4FF
dev=0 # ASUS ROG STRIX Z390-F GAMING Addressable (see `openrgb -l`)

case ${1:-static} in
  static)  args=(-m static -c "$red") ;;
  # Direct mode takes one colour per LED, in `openrgb -l` order:
  # Addressable 1 (x3), Addressable 2, Addressable 3.
  accent)  args=(-m direct -c "$red,$red_deep,$red,$volt,$red") ;;
  breathe) args=(-m breathing -c "$red") ;;
  off)     args=(-m off) ;;
  *) echo "usage: $0 [static|accent|breathe|off]" >&2; exit 1 ;;
esac

openrgb --noautoconnect -d "$dev" "${args[@]}" --save-profile rog-mech
