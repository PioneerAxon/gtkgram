public class GtkGramWindow : Gtk.ApplicationWindow
{
	private Gtk.Box main_vbox;

	public GtkGramWindow (Gtk.Application app)
	{
		Object (application: app);
		set_title ("GTK+ gram");
		main_vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
		main_vbox.show ();
	}
}
