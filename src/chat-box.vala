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
	private Gtk.ListBox message_list;
	private Gtk.Adjustment scroll;

	private string chat_id;

	public GtkGramChatBox (string chat_id)
	{
		Object (orientation: Gtk.Orientation.VERTICAL, spacing: 2);
		this.chat_id = chat_id;

		message_list = new Gtk.ListBox ();
		var scrolled_window = new Gtk.ScrolledWindow (null, null);
		scrolled_window.hscrollbar_policy = Gtk.PolicyType.NEVER;
		scrolled_window.add (message_list);
		scrolled_window.show_all ();
		scroll = scrolled_window.vadjustment;
		scrolled_window.size_allocate.connect (()=>
			{
		scroll.set_value (scroll.get_upper () - scroll.get_page_size ());
			});

		spinner = new Gtk.Spinner ();
		var loading_row = new Gtk.ListBoxRow ();
		loading_row.show ();
		loading_row.activatable = false;
		loading_row.selectable = false;
		loading_row.add (spinner);
		message_list.insert (loading_row, 0);
		pack_start (scrolled_window, true, true, 0);

		chat_input_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 2);
		var chat_input_scroll = new Gtk.ScrolledWindow (null, null);
		chat_input_scroll.hscrollbar_policy = Gtk.PolicyType.NEVER;
		chat_input_scroll.shadow_type = Gtk.ShadowType.ETCHED_IN;
		chat_input = new Gtk.TextView ();
		chat_input.set_wrap_mode (Gtk.WrapMode.WORD_CHAR);
		chat_input_scroll.add (chat_input);
		chat_input.set_pixels_above_lines (7);
		chat_input.key_press_event.connect (input_text_key_press_cb);
		chat_input.buffer.changed.connect (input_text_changed_cb);

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
		chat_input_box.pack_start (chat_input_scroll, true, true, 2);
		chat_input_box.pack_start (send_text, false, true, 2);
		chat_input_box.show_all ();

		pack_start (chat_input_box, false, true, 2);
		message_list.set_sort_func (message_list_sort_func);
		message_list.selection_mode = Gtk.SelectionMode.NONE;


		input_text_changed_cb ();
	}

	private void spinner_show ()
	{
		spinner.show ();
		spinner.start ();
		chat_input.sensitive = false;
		upload_file.sensitive = false;
		upload_image.sensitive = false;
		emoticons.sensitive = false;
		send_text.sensitive = false;
	}

	private void spinner_hide ()
	{
		spinner.stop ();
		spinner.hide ();
		chat_input.sensitive = true;
		upload_file.sensitive = true;
		upload_image.sensitive = true;
		emoticons.sensitive = true;
		send_text.sensitive = true;
	}


	public void insert_message (GtkGramMessage message)
	{
		var chat_message = new GtkGramChatMessage (message);
		message_list.insert (chat_message, -1);
		message_list.invalidate_sort ();
	}

	private int message_list_sort_func (Gtk.ListBoxRow r1, Gtk.ListBoxRow r2)
	{
		if (!r1.selectable)
			return -1;
		if (!r2.selectable)
			return 1;
		return (r1 as GtkGramChatMessage).time.compare ((r2 as GtkGramChatMessage).time);
	}

	private bool input_text_key_press_cb (Gdk.EventKey event)
	{
		bool with_shift = (event.state & (Gdk.ModifierType.SHIFT_MASK)) != 0;
		if (with_shift)
			return false;
		if (event.keyval == Gdk.Key.Return || event.keyval == Gdk.Key.KP_Enter)
		{
			send_chat_message ();
			chat_input.buffer.text = "";
			return true;
		}
		return false;
	}

	private void input_text_changed_cb ()
	{
		if (chat_input.buffer.text == null || chat_input.buffer.text.strip () == "")
		{
			upload_file.sensitive = true;
			upload_image.sensitive = true;
			send_text.sensitive = false;
		}
		else
		{
			upload_file.sensitive = false;
			upload_image.sensitive = false;
			send_text.sensitive = true;
		}
	}

	private void send_chat_message ()
	{
		if (chat_input.buffer.text == null || chat_input.buffer.text == "" || chat_input.buffer.text.strip () == "")
			return;
		GtkGramChatManager.send_message (chat_id, chat_input.buffer.text);
	}
}
