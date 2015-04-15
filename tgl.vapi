[CCode (cheader_filename="tgl/tgl.h")]
namespace Telegram
{
	[CCode (cname = "struct tgl_state", cprefix="tgl_", free_function = "tgl_free_all", has_type_id = false)]
	[Compact]
	public class TelegramState
	{
		[CCode (cname = "tgl_state_alloc")]
		public TelegramState ();
	}
}
