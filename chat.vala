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

	public GtkGramChatBox chat_box { get; private set; }
	
	private Gtk.Image chat_image;
	private Gtk.Label chat_name_label;
	private Gtk.Label chat_time_label;
	private Gtk.Label chat_text_label;

	public GtkGramChat (string chat_id, string chat_name = "Default chat", int64 chat_time = 0)
	{
		Object ();
		chat_box = new GtkGramChatBox ();

		//FIXME: Add file name handling here
		chat_image = new Gtk.Image.from_file ("");
		chat_image.width_request = 50;
		chat_image.height_request = 50;
		chat_image.expand = false;
		//FIXME: Fix Image width and height here
		chat_name_label = new Gtk.Label ("");
		chat_time_label = new Gtk.Label ("");
		//FIXME: Add last chat message content here
		chat_text_label = new Gtk.Label ("");

		var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		hbox.pack_start (chat_image, false, true, 3);
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
