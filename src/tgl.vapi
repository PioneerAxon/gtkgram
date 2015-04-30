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

		public void login ();

		[CCode (cname = "tgl_set_ev_base")]
		public void set_event_base (LibEvent.Base event_base);

		[CCode (cname = "tgl_set_net_methods")]
		public void set_network_methods (TelegramNetworkMethods net_methods);

		[CCode (cname = "tgl_set_timer_methods")]
		public void set_timer_methods (TelegramTimerMethods timer_methods);




		[CCode (cname = "tw_login_init", has_target = false)]
		public delegate void LoginAssistantInitFunc ();
		[CCode (cname = "tw_register_login_init")]
		public void login_assistant_init_register (LoginAssistantInitFunc func);

		[CCode (cname = "tw_login_get_phone", has_target = false)]
		public delegate void LoginGetPhoneFunc ();
		[CCode (cname = "tw_register_login_get_phone")]
		public void login_get_phone_register (LoginGetPhoneFunc func);
		[CCode (cname = "tw_login_set_phone_number")]
		public void set_phone_number (string phone);

		[CCode (cname = "tw_login_get_name", has_target = false)]
		public delegate void LoginGetNameFunc ();
		[CCode (cname = "tw_register_login_get_name")]
		public void login_get_name_register (LoginGetNameFunc func);
		[CCode (cname = "tw_login_set_name")]
		public void set_name (string firstname, string lastname);

		[CCode (cname = "tw_login_get_otp", has_target = false)]
		public delegate void LoginGetOTPFunc ();
		[CCode (cname = "tw_register_login_get_otp")]
		public void login_get_otp_register (LoginGetOTPFunc func);
		[CCode (cname = "tw_login_set_otp")]
		public void set_otp (string otp);
		[CCode (cname = "tw_login_set_otp_call")]
		public void send_otp_call ();

		[CCode (cname = "tw_login_destroy", has_target = false)]
		public delegate void LoginDestroyFunc ();
		[CCode (cname = "tw_register_login_destroy")]
		public void login_destroy_register (LoginDestroyFunc func);



		[CCode (cname = "tw_callback_logged_in")]
		public delegate void LoggedInFunc ();
		[CCode (cname = "tw_register_callback_logged_in")]
		public void logged_in_register_cb (LoggedInFunc func);

		[CCode (cname = "tw_callback_started")]
		public delegate void StartedFunc ();
		[CCode (cname = "tw_register_callback_started")]
		public void started_register_cb (StartedFunc func);


		[CCode (cname = "tw_callback_msg_receive")]
		public delegate void MessageReceiveFunc (TelegramMessage message);
		[CCode (cname = "tw_register_callback_msg_receive")]
		public void message_receive_register_cb (MessageReceiveFunc func);

		[CCode (cname = "tw_callback_user_update")]
		public delegate void UserUpdateFunc (TelegramUser user, UpdateFlags flags);
		[CCode (cname = "tw_register_callback_user_update")]
		public void user_update_register_cb (UserUpdateFunc func);

		[CCode (cname = "tw_callback_chat_update")]
		public delegate void ChatUpdateFunc (TelegramChat chat, UpdateFlags flags);
		[CCode (cname = "tw_register_callback_chat_update")]
		public void chat_update_register_cb (ChatUpdateFunc func);



		[CCode (cname = "tw_callback_load_photo", has_type_id = true, has_target = true)]
		public delegate void GetPhotoCallbackFunc (int success, string? filename, int64 peer_id);
		[CCode (cname = "tw_do_load_photo")]
		public void get_photo (TelegramPhoto photo, GetPhotoCallbackFunc func, int64 peer_id);

		[CCode (cname = "tw_callback_get_chat_info")]
		public delegate void GetChatInfoCallbackFunc (int success, TelegramChat chat);
		[CCode (cname = "tw_do_get_chat_info")]
		public void get_chat_info (TelegramPeerID id, GetChatInfoCallbackFunc func);

		[CCode (cname = "tw_callback_get_user_info")]
		public delegate void GetUserInfoCallbackFunc (int success, TelegramUser user);
		[CCode (cname = "tw_do_get_user_info")]
		public void get_user_info (TelegramPeerID id, GetUserInfoCallbackFunc func);



		[CCode (cname = "tgl_do_get_dialog_callback", has_type_id = false, has_target = true)]
		public delegate void GetDialogListFunc (int success, int size, [CCode (array_length = false)] TelegramPeerID[] peers, [CCode (array_length = false)] int[] message_ids, [CCode (array_length = false)] int[] unread_counts);
		[CCode (cname = "tw_do_get_dialog_list")]
		public void get_chat_list (GetDialogListFunc func);

		[CCode (cname = "tgl_peer_get")]
		public TelegramPeer? get_peer (TelegramPeerID peer_id);
	}

	[CCode (cname = "struct tgl_message", free_function = "", has_type_id = false)]
	public class TelegramMessage
	{
		public int64 id;
		public int flags;
		public TelegramPeerID fwd_from_id;
		public TelegramPeerID from_id;
		public TelegramPeerID to_id;
		public int out;
		public int unread;
		public int date;
		public int service;
		public string? message;
		public TelegramMedia? media;
		public TelegramActionMessage? action;
	}


	[CCode (cname = "int", cprefix = "TGL_PEER_", has_type_id = false)]
	public enum TelegramPeerType
	{
		UNKNOWN,
		USER,
		CHAT,
		GEO_CHAT,
		ENCR_CHAT
	}

	[CCode (cname = "int", cprefix = "TGL_UPDATE_", has_type_id = false)]
	[Flags]
	public enum UpdateFlags
	{
		CREATED,
		DELETED,
		PHONE,
		CONTACT,
		PHOTO,
		BLOCKED,
		REAL_NAME,
		NAME,
		REQUESTED,
		WORKING,
		FLAGS,
		TITLE,
		ADMIN,
		MEMBERS,
		ACCESS_HASH,
		USERNAME
	}

	[CCode (cname = "tgl_peer_id_t", free_function = "", has_type_id = false)]
	[SimpleType]
	public struct TelegramPeerID
	{
		TelegramPeerType type;
		int id;
	}

	[CCode (cname = "tgl_peer_t", free_function = "", destroy_function = "", has_type_id = false)]
	[Compact]
	public class TelegramPeer
	{
		public TelegramPeerID id;
		public int flags;
		[CCode (cname = "last")]
		public TelegramMessage last_message;
		string print_name;
		int structure_version;
		TelegramPhoto photo;
		[CCode (cname = "user.first_name")]
		public string user_firstname;
		[CCode (cname = "user.last_name")]
		public string user_lastname;
		[CCode (cname = "user.phone")]
		string user_phone;
		[CCode (cname = "user.real_first_name")]
		string user_real_first_name;
		[CCode (cname = "user.real_last_name")]
		string user_real_last_name;
		[CCode (cname = "user.username")]
		string user_username;
		[CCode (cname = "user.photo")]
		public TelegramPhoto user_photo;
		[CCode (cname = "chat.title")]
		public string chat_title;
		[CCode (cname = "chat.users_num")]
		public int chat_user_count;
		[CCode (cname = "chat.photo")]
		public TelegramPhoto chat_photo;
	}

	[CCode (cname = "struct tgl_chat", free_function = "", has_type_id = false)]
	public struct TelegramChat
	{
		[CCode (cname = "id.id")]
		int64 id;
		TelegramPhoto photo;
	}

	[CCode (cname = "struct tgl_user", free_function = "", has_type_id = false)]
	public struct TelegramUser
	{
		[CCode (cname = "id.id")]
		int64 id;
		TelegramPhoto photo;
	}

	[CCode (cname = "struct tgl_photo", free_function = "", has_type_id = false)]
	public struct TelegramPhoto
	{
	}

	[CCode (cname = "struct tgl_message_media", free_function = "", has_type_id = false)]
	public struct TelegramMedia
	{
	}

	[CCode (cname = "struct tgl_message_action", free_function = "", has_type_id = false)]
	public struct TelegramActionMessage
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
