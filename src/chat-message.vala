public class GtkGramChatMessage : Gtk.ListBoxRow
{
	private int64 id;
	private string message;
	public GLib.DateTime time { get; private set;}

	private Gtk.Label from_name;
	private Gtk.Label message_label;
	private Gtk.Label time_label;

	public GtkGramChatMessage (GtkGramMessage message)
	{
		this.id = message.message_id;
		this.message = message.message;
		this.time = message.origin_time;

		string from_user_name;
		GtkGramUser _user = GtkGramChatManager.get_user (message.from_id);
		if (_user == null || (_user.firstname == null && _user.lastname == null))
			from_user_name = "User#%lld".printf (message.from_id);
		else
		{
			from_user_name = _user.firstname;
			if (_user.lastname != null && _user.lastname != "")
				from_user_name = from_user_name + " " + _user.lastname;
		}
		bool our_message = (message.from_id == GtkGramChatManager.our_id);
		this.from_name = new Gtk.Label (from_user_name);
		this.message_label = new Gtk.Label (message.message);
//		message_label.ellipsize = Pango.EllipsizeMode.END;
		message_label.single_line_mode = false;
		message_label.wrap = true;
		message_label.halign = Gtk.Align.START;
		message_label.wrap_mode = Pango.WrapMode.WORD_CHAR;
		this.time_label = new Gtk.Label (message.origin_time.format ("%l:%M %p"));

		var hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		var title_hbox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

		title_hbox.pack_start (from_name, false, false, 2);
		title_hbox.pack_end (time_label, false, false, 2);
		vbox.pack_start (title_hbox, false, true, 2);
		vbox.pack_end (message_label, false, false, 2);

		Gtk.Image user_image;
		if (_user.image == null)
		{
			user_image = new Gtk.Image.from_icon_name ("avatar-default-symbolic", Gtk.IconSize.DIALOG);
		}
		else
		{
			user_image = new Gtk.Image.from_pixbuf (_user.image);
		}
		user_image.valign = Gtk.Align.END;
		if (!our_message)
		{
			hbox.pack_start (user_image, false, true, 3);
		}
		hbox.pack_start (vbox, true, true, 2);
		if (our_message)
		{
			hbox.pack_start (user_image, false, true, 3);
		}
		add (hbox);
		show_all ();
	}
}
