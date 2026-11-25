#!/usr/bin/env python3
# Lists every mounted partition and how full it is, in wofi (clicking the disk pill).
import os
import subprocess

WOFI = os.path.expanduser("~/.config/wofi")
SKIP = ["tmpfs", "devtmpfs", "efivarfs", "squashfs", "overlay"]


def partitions():
    out = subprocess.run(
        ["df", "-h", "--output=source,size,used,pcent,target", *[f"-x{t}" for t in SKIP]],
        capture_output=True, text=True).stdout.splitlines()[1:]
    best = {}
    for line in out:
        src, size, used, pct, target = line.split(None, 4)
        # bind mounts (e.g. microk8s pod volumes) repeat a partition; keep its shortest path
        if src not in best or len(target) < len(best[src][3]):
            best[src] = (size, used, int(pct.rstrip("%")), target)
    return sorted(best.values(), key=lambda p: p[3])


def line(size, used, pct, target):
    bar = "█" * round(pct / 10) + "░" * (10 - round(pct / 10))
    return f"{target:<11} {bar} {pct:>3}%   {used:>5} / {size}"


parts = partitions()
subprocess.run(
    ["wofi", "--dmenu", "--prompt", "Disks", "--location", "top_right",
     "--xoffset", "-8", "--yoffset", "4", "--width", "420",
     "--lines", str(len(parts) + 2), "--insensitive"],
    input="\n".join(line(*p) for p in parts), text=True,
    cwd=WOFI)  # wofi resolves its stylesheet's @import from here
