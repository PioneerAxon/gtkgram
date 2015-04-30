using Telegram;

public class GtkGramConverter
{

	public static GtkGramMessage to_GtkGramMessage (TelegramMessage m)
	{
		GtkGramMessage message = new GtkGramMessage ();
		message.message_id = m.id;
		if (m.fwd_from_id.id == 0)
		{
			message.is_forward = false;
		}
		else
		{
			message.is_forward = true;
			message.fwd_from_id = m.fwd_from_id.id;
		}
		message.from_id = m.from_id.id;
		message.to_id = m.to_id.id;
		message.is_out = (m.out != 0);
		message.is_unread = (m.unread != 0);
		message.origin_time = new GLib.DateTime.from_unix_local (m.date);
		message.is_service = (m.service != 0);
		if (message.is_service)
		{
			//TODO: Convert service messages to string here.
			message.message = "";
		}
		else
		{
			message.message = m.message;
		}
		return message;
	}
}
