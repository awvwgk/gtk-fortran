# gtk-fortran -- High level interfaces

The high level interface for gtk-fortran is in the source file
gtk-hl.f90. This provides a number of higher level interfaces to the
GTK widget system, with the intent of making GUI construction more
accessible to scientific programmers (the feel should not be too alien
to anyone who has developed GUIs in IDL). The routines make use of the
optional arguments in Fortran>=90 to simplify creating and initializing widgets.

## Modules list:

* gtk_hl: A wrapper that includes all of the other modules.

* gtk_hl_assistant: A bundled interface for the assistant widget.

* gtk_hl_button: Implements interfaces to various kinds of button.

* gtk_hl_chooser: Implements file choosers that do not need variadic
       arguments.

* gtk_hl_combobox: Implements interfaces to text comboboxes.

* gtk_hl_container: Implements interfaces to: Window, box, table
       (implemented as grid in GTK 3.x), notebook and scrolled window.

* gtk_hl_dialog: Implements a message dialog widget that does not require
       variadic calls.

* gtk_hl_entry: Implements interfaces to entry and textview widgets.

* gtk_hl_infobar: An interface to the infobar widget. Removes much of the
       complexity of putting a message into the widget.

* gtk_hl_misc: Miscellaneous interfaces, mostly used by other modules.

* gtk_hl_progress: Implements progress bars, including "m of n" settings
       and automated text addition.

* gtk_hl_spin_slider: Implements spin boxes and sliders (including
       convenient integer interfaces).

* gtk_hl_tree: Implements interfaces to the list & tree widgets.


In addition two graphics modules are available, but are not automatically
included with the gtk_hl module:

* gtk_draw_hl: Implements interfaces to drawing areas and their
       relationship to Cairo. (N.B. The reversed naming convention is a
       historical accident). Drawing areas created with this module
       have the necessary features to be used as drawing surfaces by
       plplot.

* gdk_pixbuf_hl: Implements convenient interfaces to GDK pixbufs and
       formats.

Several demos are provided in the examples/ directory: they have the
prefix hl_.
