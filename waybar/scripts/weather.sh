#!/usr/bin/env bash
# Streams the current temperature in Dunedin, NZ from Open-Meteo (no API key).
# Shows --°C straight away so startup never waits on the network, and keeps the
# last reading if a fetch fails. Refreshes every 15 minutes, retries after 30s.
url='https://api.open-meteo.com/v1/forecast?latitude=-45.87&longitude=170.50&current=temperature_2m'
temp=--

show() {
  echo "{\"text\":\"${temp}°C\",\"tooltip\":\"Dunedin, New Zealand\"}"
}

show
while :; do
  new=$(curl -fsS --max-time 10 "$url" 2>/dev/null |
    jq -r '.current.temperature_2m | round + 0' 2>/dev/null)
  if [ -n "$new" ]; then
    temp=$new
    show
    sleep 900
  else
    sleep 30
  fi
done
