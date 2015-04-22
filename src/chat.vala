public class GtkGramChat : Gtk.ListBoxRow
{
	private string _chat_name;
	public string chat_name
	{
		get
		{
			return _chat_name;
		}
		private set
		{
			chat_name_label.set_markup ("<b>" + value + "</b>");
			_chat_name = value;
		}
	}

	private GLib.DateTime _chat_time;
	public GLib.DateTime chat_time
	{
		get
		{
			return _chat_time;
		}
		private set
		{
			var now = new GLib.DateTime.now_local ();
			if (now.difference (value) < GLib.TimeSpan.DAY)
				chat_time_label.set_label (value.format ("%k:%M %p"));
			else
				chat_time_label.set_label (value.format ("%d/%m/%Y"));
			_chat_time = value;
		}
	}

	public string chat_id { get; private set; }

	public string chat_image
	{
		set
		{
			try
			{
				Gdk.Pixbuf image = new Gdk.Pixbuf.from_file_at_size (value, 50, 50);
				_chat_image.clear ();
				_chat_image.set_from_pixbuf (image);
			}
			catch (Error e)
			{
				warning ("Unable to load chat_image for %s : file %s : %s", chat_name, "", e.message);
			}
		}
	}

	public GtkGramChatBox chat_box { get; private set; }
	
	private Gtk.Image _chat_image;
	private Gtk.Label chat_name_label;
	private Gtk.Label chat_time_label;
	private Gtk.Label chat_text_label;
	private bool is_group;

	public GtkGramChat (string chat_id, string chat_name = "Default chat", int64 chat_time = 0)
	{
		Object ();
		chat_box = new GtkGramChatBox ();

		if (is_group)
			_chat_image = new Gtk.Image.from_icon_name ("system-users-symbolic", Gtk.IconSize.DIALOG);
		else
			_chat_image = new Gtk.Image.from_icon_name ("avatar-default-symbolic", Gtk.IconSize.DIALOG);
		_chat_image.width_request = 50;
		_chat_image.height_request = 50;
		_chat_image.expand = false;
		chat_name_label = new Gtk.Label ("");
		chat_time_label = new Gtk.Label ("");
		//FIXME: Add last chat message content here
		chat_text_label = new Gtk.Label ("");

		var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		hbox.pack_start (_chat_image, false, true, 3);
		var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		var name_hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		name_hbox.pack_start (chat_name_label, false, false, 2);
		name_hbox.pack_end (chat_time_label, false, false, 2);
		vbox.pack_start (name_hbox, true, true, 2);
		vbox.pack_start (chat_text_label, true, true, 2);
		hbox.pack_start (vbox, true, true, 2);

		add (hbox);

		hbox.show_all ();

		this.chat_id = chat_id;
		this.chat_name = chat_name;
		if (chat_time != 0)
			this.chat_time = new GLib.DateTime.from_unix_local (chat_time);
		else
			this.chat_time = new GLib.DateTime.now_local ();
	}
}
