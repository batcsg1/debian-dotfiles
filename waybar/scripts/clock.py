#!/usr/bin/env python3
# Waybar clock that follows the 12h/24h switch (clock-format.sh), printing one
# JSON line per second. Waybar's own clock can only change format when it is
# clicked itself, and that click opens the calendar popup.
import calendar
import datetime
import json
import os
import sys
import time

STATE = os.path.join(os.environ.get("XDG_CACHE_HOME", os.path.expanduser("~/.cache")), "waybar-clock-format")

SEP = "<span color='#555c68'> | </span>"


def hour_format():
    try:
        with open(STATE) as f:
            return "24" if f.read().strip() == "24" else "12"
    except OSError:
        return "12"


def tooltip(now):
    # same look as the old built-in tooltip: month in text, weekdays in steel, today in red
    cal = calendar.TextCalendar(firstweekday=6).formatmonth(now.year, now.month).rstrip("\n").split("\n")
    lines = [f"<span color='#d6dde6'><b>{cal[0]}</b></span>", f"<span color='#8794a6'>{cal[1]}</span>"]
    for week in cal[2:]:
        cells = [week[i:i + 3] for i in range(0, len(week), 3)]
        lines.append("".join(
            f"<span color='#ff2233'><b><u>{c}</u></b></span>" if c.strip() == str(now.day) else c
            for c in cells))
    return "<tt>" + "\n".join(lines) + "</tt>"


while True:
    now = datetime.datetime.now().astimezone()
    clock = now.strftime("%H:%M:%S" if hour_format() == "24" else "%I:%M:%S %p")
    # Nerd Font icons: clock, globe, calendar-month, calendar
    text = (f"<span color='#ff2233'>\U000f0954</span> {clock}{SEP}"
            f"<span color='#8794a6'></span> {now:%z}{SEP}"
            f"<span color='#8794a6'>\U000f0e17</span> {now:%a * %b}{SEP}"
            f"<span color='#8794a6'></span> {now:%Y-%m-%d}")
    print(json.dumps({"text": text, "tooltip": tooltip(now)}), flush=True)
    time.sleep(1 - (time.time() % 1))  # tick on the second
