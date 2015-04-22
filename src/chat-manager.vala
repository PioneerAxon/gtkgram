public class GtkGramChatManager
{
	private static GtkGramChatList _list;
	private static Gtk.Stack _stack;

	public GtkGramChatManager (owned GtkGramChatList list, owned Gtk.Stack stack)
	{
		_list = list;
		_stack = stack;
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
}
