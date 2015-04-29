public class GtkGramLogin : Gtk.Assistant
{
	private static unowned Telegram.TelegramState _t_state;
	private string phone;
	private string firstname;
	private string lastname;
	private string otp_text;

	private int _information_page_id;
	private int _phone_number_page_id;
	private int _please_wait_page_id;
	private int _signup_page_id;
	private int _signup_wait_page_id;
	private int _otp_page_id;

	private Gtk.Label please_wait;
	private Gtk.Label signup_wait;

	public GtkGramLogin (Telegram.TelegramState t_state)
	{
		Object ();
		_t_state = t_state;
		set_default_size (400, 300);
		set_title ("Login");
		try
		{
			set_icon (new Gdk.Pixbuf.from_resource_at_scale ("/org/gtkgram/logo.png", 256, 256, true));
		}
		catch (Error e)
		{
			warning ("Error opening icon : %s", e.message);
		}

		Gtk.Label information = new Gtk.Label (null);
		information.set_markup ("You are not logged in.\nThis guide will help you get started with GTK+gram.\n\n\nGTK+gram is a <a href=\"http://www.gtk.org/\">GTK+</a> client developed for <a href=\"https://telegram.org/\">Telegram</a>.");
		_information_page_id = append_page (information);
		set_page_title (information, "Information");
		set_page_type (information, Gtk.AssistantPageType.INTRO);
		set_page_complete (information, true);

		Gtk.Box phone_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
		phone_box.pack_start (new Gtk.Label ("Phone number : "));
		Gtk.Entry phone_number = new Gtk.Entry ();
		phone_box.pack_start (phone_number);
		_phone_number_page_id = append_page (phone_box);
		set_page_title (phone_box, "Phone number");
		set_page_type (phone_box, Gtk.AssistantPageType.CONTENT);
		set_page_complete (phone_box, false);
		phone_number.changed.connect (()=>{
			if (phone_number.get_text () != "")
			{
				set_page_complete (phone_box, true);
				phone = phone_number.get_text ();
			}
			else
				set_page_complete (phone_box, false);
		});

		please_wait = new Gtk.Label ("Please wait while we query Telegram server..");
		_please_wait_page_id = append_page (please_wait);
		set_page_complete (please_wait, false);
		set_page_type (please_wait, Gtk.AssistantPageType.PROGRESS);
		prepare.connect ( (widget) => {
			if (widget == please_wait)
			{
				_t_state.set_phone_number (phone);
				commit ();
			}
		});

		Gtk.Box signup = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		Gtk.Box firstname_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		Gtk.Box lastname_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		firstname_box.pack_start (new Gtk.Label ("First name : "));
		Gtk.Entry firstname_entry = new Gtk.Entry ();
		firstname_entry.changed.connect ( ()=> {
			if (firstname_entry.get_text () != "")
			{
				set_page_complete (signup, true);
				firstname = firstname_entry.get_text ();
			}
			else
				set_page_complete (signup, false);
		});
		firstname_box.pack_start (firstname_entry);
		lastname_box.pack_start (new Gtk.Label ("Last name : "));
		Gtk.Entry lastname_entry = new Gtk.Entry ();
		lastname_entry.changed.connect ( ()=> {
			lastname = lastname_entry.get_text ();
		});
		lastname_box.pack_start (lastname_entry);
		signup.pack_start (firstname_box);
		signup.pack_start (lastname_box);
		_signup_page_id = append_page (signup);
		set_page_complete (signup, false);
		set_page_type (signup, Gtk.AssistantPageType.CONTENT);
		prepare.connect ( (widget) => {
			if (widget == signup)
			{
				set_page_title (signup, "Registration");
			}
		});

		signup_wait = new Gtk.Label ("Please wait while we generate an OTP..");
		_signup_wait_page_id = append_page (signup_wait);
		set_page_complete (signup_wait, false);
		set_page_type (signup_wait, Gtk.AssistantPageType.PROGRESS);
		prepare.connect ( (widget) => {
			if (widget == signup_wait)
			{
				_t_state.set_name (firstname, lastname);
			}
		});


		Gtk.Box otp = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		otp.pack_start (new Gtk.Label ("OTP :"));
		Gtk.Entry otp_entry = new Gtk.Entry ();
		otp.pack_start (otp_entry);
		otp_entry.changed.connect ( (widget)=>{
			if (otp_entry.get_text () != "")
			{
				otp_text = otp_entry.get_text ();
				set_page_complete (otp, true);
			}
			else
				set_page_complete (otp, false);
		});
		Gtk.Button otp_call = new Gtk.Button.from_icon_name ("call-start-symbolic");
		otp_call.valign = Gtk.Align.CENTER;
		otp_call.clicked.connect (()=>{
			otp_call.sensitive = false;
			_t_state.send_otp_call ();
		});
		otp.pack_start (otp_call, false, false, 10);
		_otp_page_id = append_page (otp);
		set_page_complete (otp, false);
		set_page_type (otp, Gtk.AssistantPageType.CONFIRM);
		set_page_title (otp, "One time password");
		apply.connect (()=>{
			_t_state.set_otp (otp_text);
		});

	}

	public void get_username ()
	{
		set_current_page (_signup_page_id);
		update_buttons_state ();
		commit ();
	}

	public void get_phone ()
	{
		set_current_page (_phone_number_page_id);
		update_buttons_state ();
		commit ();
	}

	public void get_otp ()
	{
		set_current_page (_otp_page_id);
		update_buttons_state ();
		commit ();
	}

}
