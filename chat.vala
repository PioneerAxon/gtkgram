public class GtkGramChat : Gtk.ListBoxRow
{
	public string chat_name { get; private set; }
	public GLib.DateTime chat_time { get; private set; }
	public string chat_id { get; private set; }

	public GtkGramChatBox chat_box { get; private set; }
	
	public Gdk.Pixbuf chat_icon { get; set; }

	public GtkGramChat (string chat_id, string chat_name = "Default chat", GLib.DateTime? chat_time = null)
	{
		Object ();
		chat_box = new GtkGramChatBox ();
		this.chat_id = chat_id;
		this.chat_name = chat_name;
//TODO: Add time management mechanism
		
	}
}
