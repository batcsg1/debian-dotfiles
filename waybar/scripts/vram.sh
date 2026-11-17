#!/usr/bin/env bash
# VRAM in use on the NVIDIA GPU as JSON for waybar. "percentage" drives the
# low/medium/high states like the memory pill.
IFS=',' read -r NAME USED TOTAL < <(nvidia-smi --query-gpu=name,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null)
USED=${USED// /} TOTAL=${TOTAL// /}
[ -z "$TOTAL" ] && { echo '{"text":"--","tooltip":"nvidia-smi unavailable"}'; exit 0; }

PCT=$((USED * 100 / TOTAL))
GIB=$(awk "BEGIN { printf \"%.1f\", $USED / 1024 }")
echo "{\"text\":\"${GIB}G\",\"percentage\":${PCT},\"tooltip\":\"${NAME}\\nVRAM ${USED} / ${TOTAL} MiB (${PCT}%)\"}"
