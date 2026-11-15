#!/usr/bin/env bash
# "up 1 week, 2 days, 1 hour, 40 minutes" -> "1w 2d 1h 40m"
UPTIME=$(uptime -p | sed 's/^up //; s/ weeks\?/w/; s/ days\?/d/; s/ hours\?/h/; s/ minutes\?/m/; s/,//g')
echo "{\"text\":\"󰥔 ${UPTIME}\",\"tooltip\":\"System uptime\"}"
