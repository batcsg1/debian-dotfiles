#!/usr/bin/env bash
# VRAM in use on the NVIDIA GPU as JSON for waybar. The class sets the line under
# the pill (low/medium/high, same split as memory): Waybar doesn't apply "states"
# to custom modules.
IFS=',' read -r NAME USED TOTAL < <(nvidia-smi --query-gpu=name,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null)
USED=${USED// /} TOTAL=${TOTAL// /}
[ -z "$TOTAL" ] && { echo '{"text":"--","tooltip":"nvidia-smi unavailable"}'; exit 0; }

PCT=$((USED * 100 / TOTAL))
if [ "$PCT" -ge 80 ]; then LEVEL=high; elif [ "$PCT" -ge 50 ]; then LEVEL=medium; else LEVEL=low; fi
GIB=$(awk "BEGIN { printf \"%.1f\", $USED / 1024 }")
echo "{\"text\":\"${GIB}G\",\"percentage\":${PCT},\"class\":\"${LEVEL}\",\"tooltip\":\"${NAME}\\nVRAM ${USED} / ${TOTAL} MiB (${PCT}%)\"}"
