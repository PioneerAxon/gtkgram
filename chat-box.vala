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

	public GtkGramChatBox ()
	{
		Object (orientation: Gtk.Orientation.VERTICAL, spacing: 2);
		spinner = new Gtk.Spinner ();
		pack_start (spinner, true, true, 0);
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
