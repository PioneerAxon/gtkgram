public class GtkGramChatBox : Gtk.Box
{
	private Gtk.Spinner spinner;
	private bool _chat_ready;
	protected bool chat_ready
	{
		set
		{
			if (!value)
				spinner_show ();
			else
				spinner_hide ();
			_chat_ready = value;
		}
	}

	private Gtk.Box chat_input_box;
	private Gtk.TextView chat_input;
	private Gtk.Button upload_file;
	private Gtk.Button upload_image;
	private Gtk.Button emoticons;
	private Gtk.Button send_text;

	public GtkGramChatBox ()
	{
		Object (orientation: Gtk.Orientation.VERTICAL, spacing: 2);
		spinner = new Gtk.Spinner ();
		pack_start (spinner, true, true, 0);

		chat_input_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);
		chat_input = new Gtk.TextView ();

		upload_file = new Gtk.Button.from_icon_name ("document-send-symbolic");
		upload_image = new Gtk.Button.from_icon_name ("mail-send-symbolic");
		emoticons = new Gtk.Button.from_icon_name ("face-smile-symbolic");
		Gtk.Box upload_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		upload_box.get_style_context (). add_class ("linked");
		upload_box.pack_start (upload_file);
		upload_box.pack_start (upload_image);
		upload_box.pack_start (emoticons);

		send_text = new Gtk.Button.from_icon_name ("mail-replied-symbolic");

		chat_input_box.pack_start (upload_box, false, true, 2);
		chat_input_box.pack_start (chat_input, true, true, 2);
		chat_input_box.pack_start (send_text, false, true, 2);
		chat_input_box.show_all ();

		pack_start (chat_input_box, false, true, 2);
		chat_ready = false;
	}

	private void spinner_show ()
	{
		spinner.show ();
		spinner.start ();
	}

	private void spinner_hide ()
	{
		spinner.stop ();
		spinner.hide ();
	}
}
