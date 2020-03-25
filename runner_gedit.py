# runner_gedit.py
#
# Copyright (C) 2017 naheel_azawy
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import re
import os
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import GObject, Gtk, Gedit


class RunnerGeditPlugin(GObject.Object, Gedit.WindowActivatable):
    __gtype_name__ = "runner_gedit"
    window = GObject.property(type=Gedit.Window)

    def __init__(self):
        GObject.Object.__init__(self)
        self.btn = Gtk.Button("Run")
        self.btn_align = Gtk.Alignment(
            xalign=0.0, yalign=0.5, xscale=0.0, yscale=0.0)

    def do_activate(self):
        self.t = self.window.get_titlebar().get_children()[-1]
        self.t.pack_start(self.btn_align)
        self.btn_align.add(self.btn)
        self.btn_align.show_all()
        self.btn.connect("clicked", self.on_click)

    def do_deactivate(self):
        Gtk.Container.remove(self.t, self.btn)
        del self.btn

    def on_click(self, button):
        doc = self.window.get_active_document()
        f = doc.get_location()
        if f == None:
            dialog = Gtk.MessageDialog(self.window, 0, Gtk.MessageType.ERROR,
                                       Gtk.ButtonsType.OK, "Unsaved File!")
            dialog.format_secondary_text("The file must be saved first.")
            dialog.run()
            dialog.destroy()
        else:
            os.system("gnome-terminal -e 'bash -c \"rn " +
                      f.get_path().replace(" ", "\\ ") +
                      ";echo -en \\\"\\nPress ENTER to exit\\\";read A\"'")

