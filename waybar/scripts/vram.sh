#!/usr/bin/env bash
# VRAM in use and the temperature of the NVIDIA GPU as JSON for waybar. The class
# sets the line under the pill from VRAM only (low/medium/high, same split as
# memory): Waybar doesn't apply "states" to custom modules.
IFS=',' read -r NAME USED TOTAL TEMP < <(nvidia-smi --query-gpu=name,memory.used,memory.total,temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
USED=${USED// /} TOTAL=${TOTAL// /}
TEMP=$(printf '%.0f' "${TEMP// /}" 2>/dev/null) # newer drivers report decimals, e.g. 42.62
[ -z "$TOTAL" ] && { echo '{"text":"--","tooltip":"nvidia-smi unavailable"}'; exit 0; }

PCT=$((USED * 100 / TOTAL))
if [ "$PCT" -ge 80 ]; then LEVEL=high; elif [ "$PCT" -ge 50 ]; then LEVEL=medium; else LEVEL=low; fi
GIB=$(awk "BEGIN { printf \"%.1f\", $USED / 1024 }")
echo "{\"text\":\"${GIB}G <span color='#555c68'>|</span> ${TEMP}°C\",\"percentage\":${PCT},\"class\":\"${LEVEL}\",\"tooltip\":\"${NAME}\\nVRAM ${USED} / ${TOTAL} MiB (${PCT}%)\\nTemperature ${TEMP}°C\"}"
