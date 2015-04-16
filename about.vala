using Gtk;

class GtkGramAbout
{
	private const string[] authors = {
					"PioneerAxon (Arth)",
					null};
	private const string copyright = "\xc2\xa9 PioneerAxon (Arth) <arth.svnit@gmail.com>";
	private const string program_name = GETTEXT_PACKAGE;
	private const string version = VERSION;

	public static void show (Gtk.Window parent)
	{
		try
		{
			Gtk.show_about_dialog (parent,
				"program-name", program_name,
				"title", "About " + program_name,
				"version", version,
				"copyright", copyright,
				"license-type", Gtk.License.GPL_3_0,
				"comments", "A GTK+ client for Telegram",
				"authors", authors,
				"logo", new Gdk.Pixbuf.from_file_at_scale ("logo.png", 200, 200, true));
		}
		catch (Error e)
		{
			error ("Error creating about dialog : %s", e.message);
		}
	}
}
