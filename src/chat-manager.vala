using Telegram;

public class GtkGramChatManager
{
	private static GtkGramChatList _list;
	private static Gtk.Stack _stack;
	private static TelegramState t_state;
	private static LibEvent.Base ev_base;
	private static Gtk.ApplicationWindow _main_window;
	private static GtkGramLogin login;

	private static string base_directory;
	private static string download_directory;

	private static GLib.HashTable<int64?, GtkGramChat> chat_table;

	public GtkGramChatManager (owned GtkGramChatList list, owned Gtk.Stack stack, owned Gtk.ApplicationWindow main_window)
	{
		_list = list;
		_stack = stack;
		_main_window = main_window;
		ev_base = new LibEvent.Base ();
		base_directory = GLib.Environment.get_home_dir () + "/.gtkgram/";
		download_directory = base_directory + "Downloads";

		if (!(GLib.FileUtils.test (download_directory, GLib.FileTest.EXISTS) && GLib.FileUtils.test (download_directory, GLib.FileTest.IS_DIR)))
		{
			GLib.DirUtils.create_with_parents (base_directory, 0700);
			GLib.DirUtils.create_with_parents (download_directory, 0700);
			if (!(GLib.FileUtils.test (base_directory + "server.pub", GLib.FileTest.IS_REGULAR)))
			{
				GLib.File server_pub = GLib.File.new_for_uri ("resource:///org/gtkgram/rsa.pub");
				GLib.File dest_file = GLib.File.new_for_path (base_directory + "server.pub");
				try
				{
					server_pub.copy (dest_file, GLib.FileCopyFlags.OVERWRITE);
				}
				catch (GLib.Error e)
				{
					warning ("Failed to create a copy of server public key : %s\n", e.message);
				}
				warn_if_fail (GLib.FileUtils.chmod (base_directory + "server.pub", 0600) == 0);
			}
		}

		DOWNLOAD_PATH = download_directory;
		AUTH_FILE_PATH = base_directory + "auth";
		BASE_DIR_PATH = base_directory;

		t_state = new TelegramState ();
		t_state.set_event_base (ev_base);
		t_state.set_rsa_key (base_directory + "server.pub");
		t_state.set_download_directory (download_directory);
		t_state.set_network_methods (default_network_methods);
		t_state.set_timer_methods (default_libevent_timers);
		t_state.register_app_id (2899, "36722c72256a24c1225de00eb6a1ca74");
		t_state.set_app_string ("gtkgram 0.0.0");
		t_state.init ();
		login = null;
		t_state.login_assistant_init_register (()=>{
			if (login != null)
				return;
			login = new GtkGramLogin (t_state);
			login.set_transient_for (_main_window);
			login.set_modal (true);
			login.cancel.connect (()=>{
				login.destroy ();
				login = null;
				GLib.TimeVal time = TimeVal ();
				time.tv_sec = time.tv_usec = 0;
				ev_base.loopexit (time);
			});
		});
		t_state.login_get_phone_register (()=>{
			if (login.is_visible ())
			{
				login.get_phone ();
			}
			else
				login.show_all ();
		});
		t_state.login_get_name_register (()=>{
			if (login.is_visible ())
			{
				login.get_username ();
			}
		});
		t_state.login_get_otp_register (()=>{
			if (login.is_visible ())
			{
				login.get_otp ();
			}
		});
		t_state.login_destroy_register (()=>{
			if (login != null && login.is_visible ())
				login.destroy ();
		});

		t_state.logged_in_register_cb (on_logged_in);
		t_state.started_register_cb (on_started);
		t_state.message_receive_register_cb (on_message_receive);
		t_state.user_update_register_cb (on_user_update);
		t_state.chat_update_register_cb (on_chat_update);

		GLib.Timeout.add (50, ev_base_loop);
		chat_table = new GLib.HashTable<int64?, GtkGramChat> (int64_hash, int64_equal);
		t_state.login ();
	}

	public void add_chat (int chat_id, string chat_name, int chat_time, bool is_group, GtkGramMessage last_message, int unread_count)
	{
		if (chat_table.contains (chat_id))
			return;
		GtkGramChat new_chat = new GtkGramChat ("%d".printf (chat_id), chat_name, chat_time, is_group, last_message, unread_count);
		chat_table.insert (chat_id, new_chat);
		_list.insert (new_chat, -1);
		_stack.add_named (new_chat.chat_box, "%d".printf(chat_id));
		new_chat.show ();
		new_chat.chat_box.show ();
		_list.invalidate_sort ();
	}

	public bool ev_base_loop ()
	{
		ev_base.loop (LibEvent.LoopFlags.NONBLOCK);
		return !(ev_base.got_exit () || ev_base.got_break ());
	}

	public void destroy ()
	{
		if (login != null && login.is_visible ())
			login.destroy ();
	}

	private void update_list (int success, int size, TelegramPeerID[] peers, int[] message_id, int[] unread_counts)
	{
		for (int l = 0; l < size; l++)
		{
			TelegramPeer peer = t_state.get_peer (peers [l]);
			string name = "";
			bool is_group = false;
			if (peers [l].type == TelegramPeerType.USER)
			{
				name = peer.user_firstname + " " + peer.user_lastname;
				t_state.get_user_info (peers [l], on_user_info_update);
			}
			else if (peers [l].type == TelegramPeerType.CHAT)
			{
				is_group = true;
				name = peer.chat_title;
				t_state.get_chat_info (peers [l], on_chat_info_update);
			}
			add_chat (peers[l].id, name, peer.last_message.date, is_group, GtkGramConverter.to_GtkGramMessage (peer.last_message), unread_counts [l]);
		}
	}


	private void on_chat_update (TelegramChat chat, UpdateFlags flags)
	{
		if ((flags & UpdateFlags.PHOTO) != 0)
		{
			t_state.get_photo (chat.photo, (success, filename, id) => {
				if (chat_table.contains (id))
				{
					GtkGramChat _chat = chat_table.lookup (id);
					_chat.chat_image = filename;
				}
			}, chat.id);
		}
	}

	private void on_user_update (TelegramUser user, UpdateFlags flags)
	{
		if ((flags & UpdateFlags.PHOTO) != 0)
		{
			t_state.get_photo (user.photo, (success, filename, id) => {
				if (chat_table.contains (id))
				{
					GtkGramChat _chat = chat_table.lookup (id);
					_chat.chat_image = filename;
				}
			}, user.id);
		}
	}

	private void on_chat_info_update (int success, TelegramChat chat)
	{
	}

	private void on_user_info_update (int success, TelegramUser user)
	{
	}

	private void on_message_receive (TelegramMessage message)
	{
		int chat_id;
		if (message.to_id.type == TelegramPeerType.USER && message.out == 0)
		{
			chat_id = message.from_id.id;
		}
		else
		{
			chat_id = message.to_id.id;
		}
		if (chat_table.contains (chat_id))
		{
			GtkGramChat chat = chat_table.lookup (chat_id);
			chat.message_receive (GtkGramConverter.to_GtkGramMessage (message));
			_list.invalidate_sort ();
		}
	}

	private void on_logged_in ()
	{
	}

	private void on_started ()
	{
		t_state.get_chat_list (update_list);
	}

}
