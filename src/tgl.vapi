[CCode (cheader_filename="../tgl/tgl.h,../tgl/tgl-timers.h,../tgl/tgl-net.h,tgl-wrapper.h")]
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

		[CCode (cname = "tw_init")]
		public void init ();

		[CCode (cname = "tw_login_init", has_target = "false")]
		public delegate void LoginAssistantInitFunc ();

		[CCode (cname = "tw_register_login_init")]
		public void login_assistant_init_register (LoginAssistantInitFunc func);

		[CCode (cname = "tw_login_get_phone", has_target = "false")]
		public delegate void LoginGetPhoneFunc ();

		[CCode (cname = "tw_register_login_get_phone")]
		public void login_get_phone_register (LoginGetPhoneFunc func);

		[CCode (cname = "tw_login_set_phone_number")]
		public void set_phone_number (string phone);

		[CCode (cname = "tw_login_get_name", has_target = "false")]
		public delegate void LoginGetNameFunc ();

		[CCode (cname = "tw_register_login_get_name")]
		public void login_get_name_register (LoginGetNameFunc func);

		[CCode (cname = "tw_login_set_name")]
		public void set_name (string firstname, string lastname);

		[CCode (cname = "tw_login_get_otp", has_target = "false")]
		public delegate void LoginGetOTPFunc ();

		[CCode (cname = "tw_register_login_get_otp")]
		public void login_get_otp_register (LoginGetOTPFunc func);

		[CCode (cname = "tw_login_set_otp")]
		public void set_otp (string otp);

		[CCode (cname = "tw_login_set_otp_call")]
		public void send_otp_call ();

		[CCode (cname = "tw_login_destroy", has_target = "false")]
		public delegate void LoginDestroyFunc ();

		[CCode (cname = "tw_register_login_destroy")]
		public void login_destroy_register (LoginDestroyFunc func);

		public void login ();

		[CCode (cname = "tgl_set_ev_base")]
		public void set_event_base (LibEvent.Base event_base);

		[CCode (cname = "tgl_set_net_methods")]
		public void set_network_methods (TelegramNetworkMethods net_methods);

		[CCode (cname = "tgl_set_timer_methods")]
		public void set_timer_methods (TelegramTimerMethods timer_methods);
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
