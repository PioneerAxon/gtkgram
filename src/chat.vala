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
			chat_name_label.set_markup ("<b>" + GLib.Markup.escape_text (value) + "</b>");
			_chat_name = value;
		}
	}

	private string _last_message;
	public string last_message
	{
		get
		{
			return _last_message;
		}
		set
		{
			chat_text_label.set_markup (GLib.Markup.escape_text (value));
			_last_message = value;
		}
	}

	private int _unread_count;
	public int unread_count
	{
		get
		{
			return _unread_count;
		}
		set
		{
			if (value != 0)
				chat_unread_count_label.set_text ("%d".printf (value));
			else
				chat_unread_count_label.set_text (" ");
			_unread_count = value;
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
				chat_time_label.set_label (value.format ("%l:%M %p"));
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
				if (value == null || value == "")
					return;
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
	private Gtk.Label chat_unread_count_label;
	private bool is_group;


	private Notify.Notification notification;


	public GtkGramChat (string chat_id, string chat_name, int64 chat_time, bool is_group, GtkGramMessage last_message, int unread_count)
	{
		Object ();
		chat_box = new GtkGramChatBox (chat_id);

		if (is_group)
			_chat_image = new Gtk.Image.from_icon_name ("system-users-symbolic", Gtk.IconSize.DIALOG);
		else
			_chat_image = new Gtk.Image.from_icon_name ("avatar-default-symbolic", Gtk.IconSize.DIALOG);
		_chat_image.width_request = 50;
		_chat_image.height_request = 50;
		_chat_image.expand = false;
		chat_name_label = new Gtk.Label ("");
		chat_name_label.ellipsize = Pango.EllipsizeMode.END;
		chat_time_label = new Gtk.Label ("");
		chat_text_label = new Gtk.Label ("");
		chat_text_label.ellipsize = Pango.EllipsizeMode.END;
		chat_unread_count_label = new Gtk.Label ("");

		var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		hbox.pack_start (_chat_image, false, true, 3);
		var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		var name_hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		name_hbox.pack_start (chat_name_label, false, false, 2);
		name_hbox.pack_end (chat_time_label, false, false, 2);
		vbox.pack_start (name_hbox, true, true, 2);
		var message_hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		message_hbox.pack_start (chat_text_label, false, true, 2);
		message_hbox.pack_end (chat_unread_count_label, false, true, 2);
		vbox.pack_end (message_hbox, true, true, 2);
		hbox.pack_start (vbox, true, true, 2);

		add (hbox);

		hbox.show_all ();

		this.chat_id = chat_id;
		this.chat_name = chat_name;
		if (chat_time != 0)
			this.chat_time = new GLib.DateTime.from_unix_local (chat_time);
		else
			this.chat_time = new GLib.DateTime.now_local ();
		this.is_group = is_group;
		if (last_message != null)
			this.last_message = last_message.message;
		this.unread_count = unread_count;
		chat_box.insert_message (last_message);

		notification = new Notify.Notification (chat_name, null, null);
		try
		{
			notification.set_image_from_pixbuf (new Gdk.Pixbuf.from_resource_at_scale ("/org/gtkgram/logo.png", 256, 256, true));
		}
		catch (Error e)
		{}
		notification.set_timeout (5);
		notification.set_urgency (Notify.Urgency.NORMAL);
	}


	public void message_receive (GtkGramMessage message)
	{
		bool show_notify = false;
		if (message.message != null)
		{
			last_message = message.message;
			notification.body = message.message;
			show_notify = true;
		}
		if (message.is_unread)
			unread_count++;
		if (message.is_out)
		{
			unread_count = 0;
			show_notify = false;
		}
		chat_time = message.origin_time;
		if (show_notify)
		{
			try
			{
				notification.show ();
			}
			catch (Error e)
			{}
		}
		chat_box.insert_message (message);
	}
}
