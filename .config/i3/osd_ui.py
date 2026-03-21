#!/usr/bin/env python
import gi
import sys
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk, GLib

icon = sys.argv[1]
color = sys.argv[2]

class OSD(Gtk.Window):
    def __init__(self):
        # POPUP evita que i3 intente ajustarlo como una ventana normal
        Gtk.Window.__init__(self, type=Gtk.WindowType.POPUP)
        self.set_position(Gtk.WindowPosition.CENTER)
        
        # Activar transparencia para Picom
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and screen.is_composited():
            self.set_visual(visual)
        self.set_app_paintable(True)

        # Diseño CSS (Caja perfecta y dinámica)
        css = f"""
        window {{
            background-color: rgba(26, 27, 38, 0.9);
            border-radius: 20px;
            border: 2px solid {color};
        }}
        """.encode('utf-8')
        
        style_provider = Gtk.CssProvider()
        style_provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_screen(
            screen, style_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        # Etiqueta de Texto (Icono)
        label = Gtk.Label()
        label.set_markup(f"<span font='JetBrainsMono Nerd Font 70' foreground='{color}'>{icon}</span>")
        # Márgenes exactamente simétricos
        label.set_margin_top(40)
        label.set_margin_bottom(40)
        label.set_margin_start(50)
        label.set_margin_end(50)
        self.add(label)

        # Cerrar automáticamente después de 1 segundo (1000 ms)
        GLib.timeout_add(1000, Gtk.main_quit)

win = OSD()
win.show_all()
Gtk.main()
