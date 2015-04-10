public class GtkGramWindow : Gtk.ApplicationWindow
{
	private Gtk.Box main_hbox;
	private GtkGramChatList chat_list;
	private Gtk.Stack chat_stack;
	private GtkGramChatManager chat_manager;

	public GtkGramWindow (Gtk.Application app)
	{
		Object (application: app);
		set_title ("GTK+ gram");
		main_hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);

		chat_list = new GtkGramChatList ();
		chat_list.width_request = 300;
		chat_list.height_request = 400;
		chat_list.row_selected.connect (chat_selected);
		main_hbox.pack_start (chat_list, false, true, 0);

		Gtk.Separator sep = new Gtk.Separator (Gtk.Orientation.VERTICAL);
		main_hbox.pack_start (sep, false, true, 0);

		chat_stack = new Gtk.Stack ();
		chat_stack.width_request = 340;
		chat_stack.height_request = 400;
		chat_stack.margin_bottom = 6;
		chat_stack.set_transition_type (Gtk.StackTransitionType.SLIDE_UP_DOWN);
		main_hbox.pack_start (chat_stack, true, true, 2);

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

		chat_manager = new GtkGramChatManager (chat_list, chat_stack);
	}

	private void chat_selected (Gtk.ListBoxRow? row)
	{
		if (row == null)
			return;
		chat_stack.set_visible_child_name ((row as GtkGramChat).chat_id);
	}
}
