public class GtkGramChatList : Gtk.ListBox
{
	public GtkGramChatList ()
	{
		Object ();
		activate_on_single_click = true;
		selection_mode = Gtk.SelectionMode.BROWSE;
		set_sort_func (compare_chatlist_order);
	}

	private static int compare_chatlist_order (Gtk.ListBoxRow chat1, Gtk.ListBoxRow chat2)
	{
		return (chat2 as GtkGramChat).chat_time.compare ((chat1 as GtkGramChat).chat_time);
	}
}
