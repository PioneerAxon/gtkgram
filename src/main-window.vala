public class GtkGramWindow : Gtk.ApplicationWindow
{
	private Gtk.Box main_hbox;
	private GtkGramChatList chat_list;
	private Gtk.Stack chat_stack;
	private GtkGramChatManager chat_manager;
	private Gtk.HeaderBar headerbar;
	private Gtk.Button add_chat;
	private Gtk.Button find_button;

	public GtkGramWindow (Gtk.Application app)
	{
		Object (application: app);
		headerbar = new Gtk.HeaderBar ();
		headerbar.show_close_button = true;
		headerbar.title = "GTK+ gram";

		add_chat = new Gtk.Button.from_icon_name ("list-add-symbolic");
		add_chat.sensitive = false;
		add_chat.show ();
		headerbar.pack_start (add_chat);

		find_button = new Gtk.Button.from_icon_name ("system-search-symbolic");
		find_button.sensitive = false;
		find_button.show ();
		headerbar.pack_end (find_button);

		headerbar.show ();
		set_titlebar (headerbar);
		main_hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);

		Gtk.ScrolledWindow scrolled_win = new Gtk.ScrolledWindow (null, null);
		scrolled_win.hscrollbar_policy = Gtk.PolicyType.NEVER;
		chat_list = new GtkGramChatList ();
		chat_list.width_request = 300;
		chat_list.height_request = 400;
		chat_list.row_selected.connect (chat_selected);
		var chat_list_placeholder = new Gtk.Label ("No chats available.");
		chat_list_placeholder.show ();
		chat_list.set_placeholder (chat_list_placeholder);
		scrolled_win.add_with_viewport (chat_list);
		main_hbox.pack_start (scrolled_win, false, true, 0);

		Gtk.Separator sep = new Gtk.Separator (Gtk.Orientation.VERTICAL);
		main_hbox.pack_start (sep, false, true, 0);

		chat_stack = new Gtk.Stack ();
		chat_stack.width_request = 340;
		chat_stack.height_request = 400;
		chat_stack.margin_bottom = 6;
		chat_stack.margin_end = 6;
		chat_stack.set_transition_type (Gtk.StackTransitionType.SLIDE_RIGHT);
		main_hbox.pack_start (chat_stack, true, true, 2);

		add (main_hbox);
		try
		{
			set_icon (new Gdk.Pixbuf.from_resource_at_scale ("/org/gtkgram/logo.png", 256, 256, true));
		}
		catch (Error e)
		{
			warning ("Error opening icon : %s", e.message);
		}
		main_hbox.show_all ();

		chat_manager = new GtkGramChatManager (chat_list, chat_stack, this);
		this.destroy.connect (window_destroy);
	}

	private void chat_selected (Gtk.ListBoxRow? row)
	{
		if (row == null)
			return;
		chat_stack.set_visible_child_name ((row as GtkGramChat).chat_id);
	}

	public void window_destroy ()
	{
		chat_manager.destroy ();
	}
}
