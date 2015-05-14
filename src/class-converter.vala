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
			message.message = "<SERVICE>";
			message.type = GtkGramMessageType.SERVICE;
		}
		else
		{
			if (m.media.type == TelegramMediaType.photo)
			{
				message.message = "<PHOTO>";
				if (m.message != null && m.message != "")
					message.message += m.message;
				message.type = GtkGramMessageType.IMAGE;
			}
			else if (m.media.type == TelegramMediaType.document)
			{
				switch (m.media.document.flags)
				{
					case TelegramDocumentType.IMAGE:
						message.message = "<IMAGE>";
						message.type = GtkGramMessageType.IMAGE;
						break;
					case TelegramDocumentType.STICKER:
						message.message = "<STICKER>";
						message.type = GtkGramMessageType.STICKER;
						break;
					case TelegramDocumentType.ANIMATED:
						message.message = "<GIF>";
						message.type = GtkGramMessageType.IMAGE;
						break;
					case TelegramDocumentType.AUDIO:
						message.message = "<AUDIO>";
						message.type = GtkGramMessageType.AUDIO;
						break;
					case TelegramDocumentType.VIDEO:
						message.message = "<VIDEO>";
						message.type = GtkGramMessageType.VIDEO;
						break;
					default:
						message.message = "<DOCUMENT>";
						message.type = GtkGramMessageType.DOCUMENT;
						break;
				}
			}
			else if (m.media.type == TelegramMediaType.contact)
			{
				message.message = "<CONTACT>";
				message.type = GtkGramMessageType.CONTACT;
			}
			else
			{
				message.message = m.message;
				message.type = GtkGramMessageType.TEXT;
			}
		}
		return message;
	}

	public static GtkGramUser to_GtkGramUser (TelegramUser u)
	{
		GtkGramUser user = new GtkGramUser ();
		user.user_id = u.id;
		user.firstname = u.first_name;
		user.lastname = u.last_name;
		user.phone = u.phone;
		return user;
	}
}
