public class GtkGramChatList : Gtk.ListBox
{
	public GtkGramChatList ()
	{
		Object ();
		activate_on_single_click = true;
		selection_mode = Gtk.SelectionMode.BROWSE;
	}
}
