#!/usr/bin/env python3
# ROG Mech calendar popup, toggled by clicking the Waybar clock pill.
# Run it once to open, again to close. It hangs below the bar on the monitor
# the cursor is on. Scroll to change month, click the header to come back to
# today, Escape closes it.
import calendar
import datetime
import json
import os
import signal
import subprocess
import sys

import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
gi.require_version("GtkLayerShell", "0.1")
from gi.repository import Gdk, Gtk, GtkLayerShell  # noqa: E402

PIDFILE = os.path.join(os.environ.get("XDG_RUNTIME_DIR", "/tmp"), "waybar-calendar.pid")
COLORS = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "colors.css")

CSS = """
window {
    background-color: alpha(@crust, 0.95);
    border: 1px solid @red_mid;
    border-bottom: 2px solid @red;
}
* {
    font-family: "IoskeleyMonoNL NFM SC", monospace;
    font-size: 11px;
    font-weight: bold;
}
#grid { margin: 8px 12px 6px 12px; }
.month { color: @red; margin-bottom: 4px; }
.weekday { color: @volt; }
.day { color: @text; }
.today { color: @amber; text-decoration: underline; }
"""


def toggle_off():
    # a second click closes the popup that the first one opened
    try:
        with open(PIDFILE) as f:
            pid = int(f.read())
        os.kill(pid, signal.SIGTERM)
        return True
    except (OSError, ValueError):
        return False
    finally:
        try:
            os.remove(PIDFILE)
        except OSError:
            pass


def cursor_monitor(display):
    # GDK can't name outputs under Wayland, so match the focused Hyprland
    # monitor by its position in the layout
    try:
        monitors = json.loads(subprocess.run(["hyprctl", "monitors", "-j"], capture_output=True, text=True).stdout)
        focused = next(m for m in monitors if m["focused"])
    except (OSError, ValueError, StopIteration):
        return None
    for i in range(display.get_n_monitors()):
        mon = display.get_monitor(i)
        geo = mon.get_geometry()
        if geo.x == focused["x"] and geo.y == focused["y"]:
            return mon
    return None


class Calendar(Gtk.Window):
    def __init__(self):
        super().__init__()
        self.today = datetime.date.today()
        self.year, self.month = self.today.year, self.today.month

        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_namespace(self, "waybar-calendar")
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.TOP)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.TOP, True)  # top-centre, below the bar
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.TOP, 4)
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.ON_DEMAND)
        mon = cursor_monitor(self.get_display())
        if mon:
            GtkLayerShell.set_monitor(self, mon)

        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual:
            self.set_visual(visual)
        provider = Gtk.CssProvider()
        with open(COLORS) as f:
            provider.load_from_data((f.read() + CSS).encode())
        Gtk.StyleContext.add_provider_for_screen(screen, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION)

        self.grid = Gtk.Grid(column_spacing=10, row_spacing=2, name="grid")
        self.add(self.grid)
        self.fill()

        self.add_events(Gdk.EventMask.SCROLL_MASK | Gdk.EventMask.BUTTON_PRESS_MASK)
        self.connect("scroll-event", self.on_scroll)
        self.connect("button-press-event", self.on_click)
        self.connect("key-press-event", self.on_key)
        self.connect("destroy", Gtk.main_quit)

    def fill(self):
        for child in self.grid.get_children():
            self.grid.remove(child)
        title = Gtk.Label(label=f"{calendar.month_name[self.month]} {self.year}", xalign=0)
        title.get_style_context().add_class("month")
        self.grid.attach(title, 0, 0, 7, 1)
        for col, name in enumerate(("Su", "Mo", "Tu", "We", "Th", "Fr", "Sa")):
            label = Gtk.Label(label=name)
            label.get_style_context().add_class("weekday")
            self.grid.attach(label, col, 1, 1, 1)
        # weeks start on Sunday, like the Waybar tooltip
        for row, week in enumerate(calendar.Calendar(firstweekday=6).monthdayscalendar(self.year, self.month), start=2):
            for col, day in enumerate(week):
                label = Gtk.Label(label=f"{day:2d}" if day else "", xalign=1)
                label.get_style_context().add_class("day")
                if day and datetime.date(self.year, self.month, day) == self.today:
                    label.get_style_context().add_class("today")
                self.grid.attach(label, col, row, 1, 1)
        self.grid.show_all()

    def shift(self, months):
        index = self.year * 12 + self.month - 1 + months
        self.year, self.month = divmod(index, 12)
        self.month += 1
        self.fill()

    def on_scroll(self, _widget, event):
        if event.direction == Gdk.ScrollDirection.UP:
            self.shift(-1)
        elif event.direction == Gdk.ScrollDirection.DOWN:
            self.shift(1)
        elif event.direction == Gdk.ScrollDirection.SMOOTH:
            _, _, dy = event.get_scroll_deltas()
            if dy:
                self.shift(1 if dy > 0 else -1)
        return True

    def on_click(self, _widget, _event):
        self.year, self.month = self.today.year, self.today.month
        self.fill()
        return True

    def on_key(self, _widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.destroy()
        return True


if __name__ == "__main__":
    if toggle_off():
        sys.exit()
    with open(PIDFILE, "w") as f:
        f.write(str(os.getpid()))
    signal.signal(signal.SIGTERM, lambda *_: Gtk.main_quit())
    try:
        Calendar().show_all()
        Gtk.main()
    finally:
        if os.path.exists(PIDFILE) and open(PIDFILE).read() == str(os.getpid()):
            os.remove(PIDFILE)
