#!/usr/bin/env rn
using Gtk;

int main (string[] args) {
	Gtk.init (ref args);

	var window = new Window ();
	window.title = "A Little GTK+ Program";
	window.border_width = 10;
	window.window_position = WindowPosition.CENTER;
	window.set_default_size (350, 70);
	window.destroy.connect (Gtk.main_quit);

	var button = new Button.with_label ("Click me!");
	button.clicked.connect (() => {
		Gtk.main_quit ();
	});

	window.add (button);
	window.show_all ();

	Gtk.main ();
	return 0;
}
