public class GtkGramWindow : Gtk.ApplicationWindow
{
	private Gtk.Box main_hbox;
	private Gtk.StackSidebar main_sidebar;
	private Gtk.Stack main_stack;

	public GtkGramWindow (Gtk.Application app)
	{
		Object (application: app);
		set_title ("GTK+ gram");
		main_hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);

		main_sidebar = new Gtk.StackSidebar ();
		main_sidebar.width_request = 300;
		main_sidebar.height_request = 400;
		main_hbox.pack_start (main_sidebar, false, true, 0);

		Gtk.Separator sep = new Gtk.Separator (Gtk.Orientation.VERTICAL);
		main_hbox.pack_start (sep, false, true, 0);

		main_stack = new Gtk.Stack ();
		main_stack.width_request = 340;
		main_stack.height_request = 400;
		main_hbox.pack_start (main_stack);
		main_sidebar.set_stack (main_stack);

		add (main_hbox);
		try
		{
			set_icon (new Gdk.Pixbuf.from_file ("logo.png"));
		}
		catch (Error e)
		{
			warning ("Error opening icon : %s", e.message);
		}
		main_hbox.show_all ();
	}
}
