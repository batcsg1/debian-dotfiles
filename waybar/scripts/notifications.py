#!/usr/bin/env python3
# Waybar notification pill, backed by mako's history.
#   notifications.py        print the pill: a bell and the number of unread notifications
#   notifications.py open   list recent notifications in wofi and mark them read
#   notifications.py dnd    toggle Do Not Disturb (mako's do-not-disturb mode)
import json
import os
import subprocess
import sys

CACHE = os.environ.get("XDG_CACHE_HOME", os.path.expanduser("~/.cache"))
SEEN = os.path.join(CACHE, "waybar-notifications-seen")  # highest id already looked at
WOFI = os.path.expanduser("~/.config/wofi")
BELL, BELL_OFF = "\U000f009a", "\U000f009b"


def history():
    # makoctl's text history leaves out the bodies, so ask mako over D-Bus
    out = subprocess.run(
        ["busctl", "--user", "--json=short", "call", "org.freedesktop.Notifications",
         "/fr/emersion/Mako", "fr.emersion.Mako", "ListHistory"],
        capture_output=True, text=True).stdout
    try:
        items = json.loads(out)["data"][0]
    except (ValueError, KeyError, IndexError):
        return []
    # mako lists oldest first; newest first reads better
    return [{k: v["data"] for k, v in n.items()} for n in reversed(items)]


def seen(notes):
    try:
        with open(SEEN) as f:
            last = int(f.read())
    except (OSError, ValueError):
        return 0
    # mako numbers from 1 again after a restart, so a mark above every current
    # id is left over from before it
    return last if any(n["id"] >= last for n in notes) else 0


def dnd():
    out = subprocess.run(["makoctl", "mode"], capture_output=True, text=True).stdout
    return "do-not-disturb" in out.split()


def refresh():
    # redraw the pill (signal 7 in config.jsonc)
    subprocess.run(["pkill", "-RTMIN+7", "-x", "waybar"])


def status():
    notes = history()
    unread = sum(1 for n in notes if n["id"] > seen(notes))
    quiet = dnd()
    text = BELL_OFF if quiet else (f"{BELL} {unread}" if unread else BELL)
    tip = ("Do Not Disturb is on\n" if quiet else "") + \
        f"{len(notes)} recent notification{'s' * (len(notes) != 1)}\nClick: show  ·  Right-click: Do Not Disturb"
    cls = "dnd" if quiet else ("unread" if unread else "read")
    print(json.dumps({"text": text, "tooltip": tip, "class": cls}))


def show():
    notes = history()
    if notes:
        with open(SEEN, "w") as f:
            f.write(str(max(n["id"] for n in notes)))
    refresh()
    lines = []
    for n in notes:
        body = " ".join(n.get("body", "").split())
        app = n.get("app-name") or "notification"
        lines.append(f"{app} — {n.get('summary', '')}" + (f": {body}" if body else ""))
    subprocess.run(
        ["wofi", "--dmenu", "--prompt", "Notifications", "--location", "top_right",
         "--xoffset", "-8", "--yoffset", "4", "--width", "460",
         "--lines", str(min(max(len(lines), 1), 10) + 1), "--insensitive"],
        input="\n".join(lines or ["No recent notifications"]), text=True,
        cwd=WOFI)  # wofi resolves its stylesheet's @import from here


if __name__ == "__main__":
    action = sys.argv[1] if len(sys.argv) > 1 else ""
    if action == "open":
        show()
    elif action == "dnd":
        subprocess.run(["makoctl", "mode", "-t", "do-not-disturb"])
        refresh()
    else:
        status()
