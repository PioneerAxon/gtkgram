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

		this.from_name = new Gtk.Label ("%lld".printf (message.from_id));
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
		hbox.pack_start (vbox, true, true, 2);
		add (hbox);
		show_all ();
	}
}
