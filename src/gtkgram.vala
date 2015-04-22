public class GtkGram : Gtk.Application
{

	private GtkGramWindow window;
	private const GLib.ActionEntry[] app_entries =
	{
		{"about", about_cb, null, null, null},
		{"quit", quit_cb, null, null, null},
	};

	protected override void startup ()
	{
		base.startup ();
		add_action_entries (app_entries, this);
		window = new GtkGramWindow (this);
		Gtk.Builder builder = new Gtk.Builder ();
		try
		{
			builder.add_from_string (UIStrings.appmenu_string, -1);
		}
		catch (Error e)
		{
			error ("Error loading UI strings : %s", e.message);
		}
		var menu = builder.get_object ("appmenu") as MenuModel;
		set_app_menu (menu);
	}

	protected override void activate ()
	{
		window.present ();
	}

	private void about_cb ()
	{
		GtkGramAbout.show (window);
	}

	private void quit_cb ()
	{
		window.destroy ();
	}
}

int main (string[] args)
{
	var app = new GtkGram ();
	return app.run (args);
}
