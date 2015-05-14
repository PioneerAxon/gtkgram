public class GtkGramMessage
{
	public int64 message_id;
	public bool is_forward;
	public int64 fwd_from_id;
	public int64 from_id;
	public int64 to_id;
	public bool is_out;
	public bool is_unread;
	public GLib.DateTime origin_time;
	public bool is_service;
	public GtkGramMessageType type;
	public string? message;
}

public enum GtkGramMessageType
{
	SERVICE,
	TEXT,
	IMAGE,
	AUDIO,
	VIDEO,
	STICKER,
	DOCUMENT,
	CONTACT,
}
