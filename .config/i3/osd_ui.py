#!/usr/bin/env python
"""Caps Lock / Num Lock OSD: a rounded box with an icon, centered on screen.

Usage: osd_ui.py <icon> <#rrggbb>

The icon is centered by its ink bounds (the pixels actually drawn), not by
font metrics. Nerd Font glyphs have advance widths and ascent/descent values
that don't match their drawing, which is why a plain Gtk.Label with symmetric
margins always looked off-center.
"""
import math
import sys

import cairo
import gi

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
gi.require_version("PangoCairo", "1.0")
from gi.repository import Gdk, GLib, Gtk, Pango, PangoCairo  # noqa: E402

SIZE = 180                          # Box side in px
RADIUS = 12                         # Same as picom's corner-radius
BORDER = 2
ICON_FONT = "JetBrainsMono Nerd Font 64"
BACKGROUND = (26 / 255, 27 / 255, 38 / 255, 0.92)   # TokyoNight #1a1b26
TIMEOUT_MS = 1000


def hex_to_rgb(value):
    value = value.lstrip("#")
    return tuple(int(value[i:i + 2], 16) / 255 for i in (0, 2, 4))


def rounded_rect(cr, x, y, w, h, r):
    cr.new_sub_path()
    cr.arc(x + w - r, y + r, r, -math.pi / 2, 0)
    cr.arc(x + w - r, y + h - r, r, 0, math.pi / 2)
    cr.arc(x + r, y + h - r, r, math.pi / 2, math.pi)
    cr.arc(x + r, y + r, r, math.pi, 3 * math.pi / 2)
    cr.close_path()


class OSD(Gtk.Window):
    def __init__(self, icon, color):
        self.icon = icon
        self.color = color
        # POPUP (override-redirect): i3 does not manage or tile it.
        super().__init__(type=Gtk.WindowType.POPUP)
        self.set_size_request(SIZE, SIZE)
        self.set_app_paintable(True)

        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)

        area = Gtk.DrawingArea()
        area.connect("draw", self.on_draw)
        self.add(area)

        self.move_to_pointer_monitor_center()
        GLib.timeout_add(TIMEOUT_MS, Gtk.main_quit)

    def move_to_pointer_monitor_center(self):
        display = Gdk.Display.get_default()
        _, px, py = display.get_default_seat().get_pointer().get_position()
        geometry = display.get_monitor_at_point(px, py).get_geometry()
        self.move(geometry.x + (geometry.width - SIZE) // 2,
                  geometry.y + (geometry.height - SIZE) // 2)

    def on_draw(self, widget, cr):
        draw_osd(cr, widget.get_allocated_width(), widget.get_allocated_height(),
                 self.icon, self.color)
        return False


def draw_osd(cr, width, height, icon, color):
    red, green, blue = hex_to_rgb(color)

    # Fully transparent canvas, then the rounded box with its border.
    cr.set_operator(cairo.OPERATOR_SOURCE)
    cr.set_source_rgba(0, 0, 0, 0)
    cr.paint()
    cr.set_operator(cairo.OPERATOR_OVER)

    half = BORDER / 2
    rounded_rect(cr, half, half, width - BORDER, height - BORDER, RADIUS)
    cr.set_source_rgba(*BACKGROUND)
    cr.fill_preserve()
    cr.set_source_rgba(red, green, blue, 0.9)
    cr.set_line_width(BORDER)
    cr.stroke()

    # Icon centered by its ink rectangle (Pango units -> px, sub-pixel exact).
    layout = PangoCairo.create_layout(cr)
    layout.set_font_description(Pango.FontDescription.from_string(ICON_FONT))
    layout.set_text(icon, -1)
    ink, _ = layout.get_extents()
    ink_x = ink.x / Pango.SCALE
    ink_y = ink.y / Pango.SCALE
    ink_w = ink.width / Pango.SCALE
    ink_h = ink.height / Pango.SCALE

    cr.move_to((width - ink_w) / 2 - ink_x, (height - ink_h) / 2 - ink_y)
    cr.set_source_rgb(red, green, blue)
    PangoCairo.show_layout(cr, layout)


if __name__ == "__main__":
    GLib.set_prgname("lock-osd")
    win = OSD(sys.argv[1], sys.argv[2])
    win.show_all()
    Gtk.main()
