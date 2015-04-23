using Telegram;

public class GtkGramChatManager
{
	private static GtkGramChatList _list;
	private static Gtk.Stack _stack;
	private static TelegramState t_state;
	private static LibEvent.Base ev_base;
	private static GtkGramService service;

	public GtkGramChatManager (owned GtkGramChatList list, owned Gtk.Stack stack)
	{
		_list = list;
		_stack = stack;
		ev_base = new LibEvent.Base ();

		t_state = new TelegramState ();
		t_state.set_event_base (ev_base);
		t_state.set_rsa_key ("../data/rsa.pub");
		t_state.set_download_directory ("/tmp");
		t_state.set_network_methods (default_network_methods);
		t_state.set_timer_methods (default_libevent_timers);
		t_state.register_app_id (2899, "36722c72256a24c1225de00eb6a1ca74");
		t_state.set_app_string ("gtkgram 0.0.0");
		t_state.init ();
		t_state.login ();

		service = new GtkGramService (t_state, ev_base);
		service.start_ev_loop ();
	}

	public void add_chat (string chat_id, string chat_name = "", int chat_time = 0)
	{
		GtkGramChat new_chat = new GtkGramChat (chat_id, chat_name, chat_time);
		_list.insert (new_chat, -1);
		_stack.add_named (new_chat.chat_box, chat_id);
		new_chat.show ();
		new_chat.chat_box.show ();
		_list.invalidate_sort ();
	}

	public void destroy ()
	{
		service.stop_ev_loop ();
	}
}
