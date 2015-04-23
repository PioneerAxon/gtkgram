public class GtkGramService
{
	private static GLib.Thread<int> service_thread;
	private static unowned Telegram.TelegramState t_state;
	private static unowned LibEvent.Base ev_base;

	public GtkGramService (Telegram.TelegramState state, LibEvent.Base _base)
	{
		t_state = state;
		ev_base = _base;
	}

	public void start_ev_loop ()
	{
		service_thread = new GLib.Thread<int> ("Telegram Service thread", internal_loop );
	}

	public void stop_ev_loop ()
	{
		ev_base.loopbreak ();
		service_thread.join ();
	}

	private int internal_loop ()
	{
		while (true)
		{
			ev_base.loop (LibEvent.LoopFlags.ONCE);
			if (ev_base.got_exit () || ev_base.got_break ())
			{
				return 0;
			}
		}
	}
}
