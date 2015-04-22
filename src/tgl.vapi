[CCode (cheader_filename="../tgl/tgl.h,../tgl/tgl-timers.h,../tgl/tgl-net.h")]
namespace Telegram
{
	[CCode (cname = "struct tgl_state", cprefix="tgl_", free_function = "tgl_free_all", has_type_id = false)]
	[Compact]
	public class TelegramState
	{
		[CCode (cname = "tgl_state_alloc")]
		public TelegramState ();

		[CCode (cname = "tgl_set_rsa_key")]
		public void set_rsa_key (string path);

		public void set_download_directory (string path);

		public void register_app_id (int app_id, string app_hash);

		[CCode (cname = "tgl_set_app_version")]
		public void set_app_string (string app_name);

		public void enable_ipv6 ();

		public void init ();

		public void login ();

		[CCode (cname = "tgl_set_ev_base")]
		public void set_event_base (LibEvent.Base event_base);

		[CCode (cname = "tgl_set_net_methods")]
		public void set_network_methods (TelegramNetworkMethods net_methods);

		[CCode (cname = "tgl_set_timer_methods")]
		public void set_timer_methods (TelegramTimerMethods timer_methods);

		[CCode (cname = "new_msg")]
		public delegate void new_message (TelegramMessage message);

		[CCode (cname = "struct tgl_update_callback", has_type_id = false)]
		public struct callbacks
		{
			[CCode (delegate_target_name = "new_msg")]
			public unowned new_message callback;
		}
	}

	[CCode (cname = "struct tgl_message", free_function = "", has_type_id = false)]
	public class TelegramMessage
	{
	}

	[CCode (cname = "struct tgl_net_methods", free_function = "", has_type_id = false, default_value = "tgl_conn_methods")]
	public struct TelegramNetworkMethods
	{
	}

	[CCode (cname="tgl_conn_methods")]
	public static const TelegramNetworkMethods default_network_methods;

	[CCode (cname = "struct tgl_timer_methods", free_function = "", has_type_id = false, default_value = "tgl_libevent_timers")]
	public struct TelegramTimerMethods
	{
	}

	[CCode (cname="tgl_libevent_timers")]
	public static const TelegramTimerMethods default_libevent_timers;
}
