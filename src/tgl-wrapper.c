#include "../tgl/tgl-binlog.h"
#include "tgl-wrapper.h"

#include <assert.h>
#include <stdio.h>
#include <fcntl.h>

typedef void (*tw_get_phone_cb) (struct tgl_state* TLS, char* string, void* arg);
typedef void (*tw_get_name_cb) (struct tgl_state* TLS, char* string, void* arg);
typedef void (*tw_get_otp_cb) (struct tgl_state* TLS, char* string, void* arg);

tw_login_init tw_login_init_func;

tw_login_get_phone tw_login_get_phone_func;
tw_get_phone_cb tw_get_phone_cb_func;

tw_login_get_name tw_login_get_name_func;
tw_get_name_cb tw_get_name_cb_func;

tw_login_get_otp tw_login_get_otp_func;
tw_get_otp_cb tw_get_otp_cb_func;

tw_login_destroy tw_login_destroy_func;

static char* last_name;
static void* name_data;
static void* otp_data;

void
tw_register_login_init (struct tgl_state* TLS, tw_login_init login_init_func)
{
	tw_login_init_func = login_init_func;
}

void
tw_register_login_get_phone (struct tgl_state* TLS, tw_login_get_phone login_phone_func)
{
	tw_login_get_phone_func = login_phone_func;
}

void
tw_register_login_get_name (struct tgl_state* TLS, tw_login_get_name login_name_func)
{
	tw_login_get_name_func = login_name_func;
}

void
tw_register_login_get_otp (struct tgl_state* TLS, tw_login_get_otp login_otp_func)
{
	tw_login_get_otp_func = login_otp_func;
}

void
tw_register_login_destroy (struct tgl_state* TLS, tw_login_destroy login_destroy_func)
{
	tw_login_destroy_func = login_destroy_func;
}

void
tw_login_set_phone_number (struct tgl_state* TLS, char* phone)
{
	if (tw_get_phone_cb_func)
		tw_get_phone_cb_func (TLS, phone, NULL);
	tw_get_phone_cb_func = NULL;
}

void
tw_login_set_name (struct tgl_state* TLS, char* firstname, char* lastname)
{
	if (lastname)
		last_name = lastname;
	else
		last_name = "";
	if (tw_get_name_cb_func)
		tw_get_name_cb_func (TLS, firstname, name_data);
	name_data = NULL;
	tw_get_name_cb_func = NULL;
}

void
tw_login_set_otp (struct tgl_state* TLS, char* otp)
{
	if (tw_get_otp_cb_func)
		tw_get_otp_cb_func (TLS, otp, otp_data);
	otp_data = NULL;
	tw_get_otp_cb_func = NULL;
}

void
tw_login_set_otp_call (struct tgl_state* TLS)
{
	tw_login_set_otp (TLS, "call");
}



void
tw_get_string (struct tgl_state* TLS, const char* prompt, int flags, void (*callback) (struct tgl_state* TLS, char* string, void* arg), void *arg)
{
	if (strncmp (prompt, "phone number:", strlen ("phone number:")) == 0)
	{
		tw_get_phone_cb_func = callback;
		if (tw_login_get_phone_func)
		{
			if (tw_login_init_func)
				tw_login_init_func (TLS);
			tw_login_get_phone_func (TLS);
		}
	}
	else if (strncmp (prompt, "register [Y/n]:", strlen ("register [Y/n]:")) == 0)
	{
		callback (TLS, "y", arg);
	}
	else if (strncmp (prompt, "First name:", strlen ("First name:")) == 0)
	{
		tw_get_name_cb_func = callback;
		if (tw_login_get_name_func)
		{
			name_data = arg;
			tw_login_get_name_func (TLS);
		}
	}
	else if (strncmp (prompt, "Last name:", strlen ("Last name:")) == 0)
	{
		callback (TLS, last_name, arg);
	}
	else if (strncmp (prompt, "code ('call' for phone call):", strlen ("code ('call' for phone call):")) == 0)
	{
		tw_get_otp_cb_func = callback;
		if (tw_login_get_otp_func)
		{
			otp_data = arg;
			tw_login_get_otp_func (TLS);
		}
	}
	else
		fprintf (stderr, "Unknown get %s %d %x\n", prompt, flags, arg);
}

tw_callback_logged_in tw_cb_logged_in_func;
void* tw_cb_logged_in_data;
tw_callback_started tw_cb_started_func;
void* tw_cb_started_data;

void
tw_register_callback_logged_in (struct tgl_state* TLS, tw_callback_logged_in func, void* data)
{
	tw_cb_logged_in_func = func;
	tw_cb_logged_in_data = data;
}

void
tw_register_callback_started (struct tgl_state* TLS, tw_callback_started func, void* data)
{
	tw_cb_started_func = func;
	tw_cb_started_data = data;
}



static void
write_dc (struct tgl_dc* DC, void* extra)
{
	int auth_file_fd = *(int *)extra;
	if (!DC)
	{
		int x = 0;
		assert (write (auth_file_fd, &x, 4) == 4);
		return;
	}
	else
	{
		int x = 1;
		assert (write (auth_file_fd, &x, 4) == 4);
	}

	assert (DC->has_auth);

	assert (write (auth_file_fd, &DC->port, 4) == 4);
	int l = strlen (DC->ip);
	assert (write (auth_file_fd, &l, 4) == 4);
	assert (write (auth_file_fd, DC->ip, l) == l);
	assert (write (auth_file_fd, &DC->auth_key_id, 8) == 8);
	assert (write (auth_file_fd, DC->auth_key, 256) == 256);
}


static void
export_auth_file (struct tgl_state* TLS)
{
	int auth_file_fd = open (AUTH_FILE_PATH, O_CREAT | O_RDWR, 0600);
	assert (auth_file_fd >= 0);
	int x = DC_SERIALIZED_MAGIC;
	assert (write (auth_file_fd, &x, 4) == 4);
	assert (write (auth_file_fd, &TLS->max_dc_num, 4) == 4);
	assert (write (auth_file_fd, &TLS->dc_working_num, 4) == 4);

	tgl_dc_iterator_ex (TLS, write_dc, &auth_file_fd);

	assert (write (auth_file_fd, &TLS->our_id, 4) == 4);
	close (auth_file_fd);
}

static void
read_dc (struct tgl_state* TLS, int auth_file_fd, int id, unsigned ver)
{
	int port = 0;
	assert (read (auth_file_fd, &port, 4) == 4);
	int l = 0;
	assert (read (auth_file_fd, &l, 4) == 4);
	assert (l >= 0 && l < 100);
	char ip[100];
	assert (read (auth_file_fd, ip, l) == l);
	ip[l] = 0;

	long long auth_key_id;
	static unsigned char auth_key[256];
	assert (read (auth_file_fd, &auth_key_id, 8) == 8);
	assert (read (auth_file_fd, auth_key, 256) == 256);

	bl_do_dc_option (TLS, id, 2, "DC", l, ip, port);
	bl_do_set_auth_key_id (TLS, id, auth_key);
	bl_do_dc_signed (TLS, id);
}


static void
empty_auth_file (struct tgl_state* TLS)
{
	if (TLS->test_mode)
	{
		bl_do_dc_option (TLS, 1, 0, "", strlen (TG_SERVER_TEST_1), TG_SERVER_TEST_1, 443);
		bl_do_dc_option (TLS, 2, 0, "", strlen (TG_SERVER_TEST_2), TG_SERVER_TEST_2, 443);
		bl_do_dc_option (TLS, 3, 0, "", strlen (TG_SERVER_TEST_3), TG_SERVER_TEST_3, 443);
		bl_do_set_working_dc (TLS, 2);
	}
	else
	{
		bl_do_dc_option (TLS, 1, 0, "", strlen (TG_SERVER_1), TG_SERVER_1, 443);
		bl_do_dc_option (TLS, 2, 0, "", strlen (TG_SERVER_2), TG_SERVER_2, 443);
		bl_do_dc_option (TLS, 3, 0, "", strlen (TG_SERVER_3), TG_SERVER_3, 443);
		bl_do_dc_option (TLS, 4, 0, "", strlen (TG_SERVER_4), TG_SERVER_4, 443);
		bl_do_dc_option (TLS, 5, 0, "", strlen (TG_SERVER_5), TG_SERVER_5, 443);
		bl_do_set_working_dc (TLS, 4);
	}
}

static void
import_auth_file (struct tgl_state* TLS)
{
	int auth_file_fd = open (AUTH_FILE_PATH, O_CREAT | O_RDWR, 0600);
	if (auth_file_fd < 0)
	{
		empty_auth_file (TLS);
		return;
	}
	assert (auth_file_fd >= 0);
	unsigned x;
	unsigned m;
	if (read (auth_file_fd, &m, 4) < 4 || (m != DC_SERIALIZED_MAGIC))
	{
		close (auth_file_fd);
		empty_auth_file (TLS);
		return;
	}
	assert (read (auth_file_fd, &x, 4) == 4);
	assert (x > 0);
	int dc_working_num;
	assert (read (auth_file_fd, &dc_working_num, 4) == 4);

	int i;
	for (i = 0; i <= (int)x; i++)
	{
		int y;
		assert (read (auth_file_fd, &y, 4) == 4);
		if (y) {
			read_dc (TLS, auth_file_fd, i, m);
		}
	}
	bl_do_set_working_dc (TLS, dc_working_num);
	int our_id;
	int l = read (auth_file_fd, &our_id, 4);
	if (l < 4)
	{
		assert (!l);
	}
	if (our_id)
	{
		bl_do_set_our_id (TLS, our_id);
	}
	close (auth_file_fd);
	printf ("Successfully read auth file\n");
}

void
tw_new_msg (struct tgl_state* TLS, struct tgl_message *M)
{
	printf ("In new_message\n");
}

void
tw_marked_read (struct tgl_state* TLS, int num, struct tgl_message *list[])
{
	printf ("In marked_read %d\n", num);
}

void
tw_logged_in (struct tgl_state* TLS)
{
	if (tw_login_destroy_func)
		tw_login_destroy_func (TLS);

	if (tw_cb_logged_in_func)
		tw_cb_logged_in_func (TLS, tw_cb_logged_in_data);

	export_auth_file (TLS);
}

void
tw_started (struct tgl_state* TLS)
{
	if (tw_cb_started_func)
		tw_cb_started_func (TLS, tw_cb_started_data);
}

void
tw_type_notification (struct tgl_state* TLS, struct tgl_user* U, enum tgl_typing_status status)
{
	printf ("In type_notification %d\n", status);
}

void
tw_type_in_chat_notification (struct tgl_state* TLS, struct tgl_user* U, struct tgl_chat* C, enum tgl_typing_status status)
{
	printf ("In type_in_chat_notification %d\n", status);
}

void
tw_type_in_secret_chat_notification (struct tgl_state* TLS, struct tgl_user* U, struct tgl_chat* C, enum tgl_typing_status status)
{
	printf ("In type_in_secret_chat_notification %d\n", status);
}

void
tw_status_notification (struct tgl_state* state, struct tgl_user* U)
{
	printf ("In status_notification\n");
}

void
tw_user_registered (struct tgl_state* TLS, struct tgl_user* U)
{
	printf ("In user_registered\n");
}

void
tw_user_activated (struct tgl_state* TLS, struct tgl_user* U)
{
	printf ("In user_activated\n");
}

void
tw_new_authorization (struct tgl_state* TLS, const char* device, const char* location)
{
	printf ("In new_authorization (%s, %s)\n", device, location);
}

void
tw_chat_update (struct tgl_state* TLS, struct tgl_chat* C, unsigned flags)
{
	printf ("In chat_update %d\n", flags);
}

void
tw_user_update (struct tgl_state* TLS, struct tgl_user * U, unsigned flags)
{
	printf ("In user_update %d\n", flags);
}

void
tw_secret_chat_update (struct tgl_state* TLS, struct tgl_secret_chat* C, unsigned flags)
{
	printf ("In secret_chat_update %d\n", flags);
}

void
tw_msg_receive (struct tgl_state* TLS, struct tgl_message* M)
{
	printf ("In msg_receive\n");
}

void
tw_our_id (struct tgl_state* TLS, int our_id)
{
	printf ("In our_id %d\n", our_id);
}

void
tw_notification (struct tgl_state* TLS, char* type, char* message)
{
	printf ("In notification %s %s\n", type, message);
}

void
tw_user_status_update (struct tgl_state* TLS, struct tgl_user* U)
{
	printf ("In user_status_update\n");
}

char*
tw_create_print_name (struct tgl_state* TLS, tgl_peer_id_t id, const char* a1, const char* a2, const char* a3, const char* a4)
{
	printf ("In create_print_name (%s, %s, %s, %s)\n", a1, a2, a3, a4);
}

static void
_tw_read_configs (struct tgl_state* TLS)
{
	assert (TLS);
	import_auth_file (TLS);
//	bl_do_reset_authorization (TLS);

	TLS->callback.new_msg = tw_new_msg;
	TLS->callback.marked_read = tw_marked_read;
	TLS->callback.get_string = tw_get_string;
	TLS->callback.logged_in = tw_logged_in;
	TLS->callback.started = tw_started;
	TLS->callback.type_notification = tw_type_notification;
	TLS->callback.type_in_chat_notification = tw_type_in_chat_notification;
	TLS->callback.type_in_secret_chat_notification = tw_type_in_secret_chat_notification;
	TLS->callback.status_notification = tw_status_notification;
	TLS->callback.user_registered = tw_user_registered;
	TLS->callback.user_activated = tw_user_activated;
	TLS->callback.new_authorization = tw_new_authorization;
	TLS->callback.chat_update = tw_chat_update;
	TLS->callback.user_update = tw_user_update;
	TLS->callback.secret_chat_update = tw_secret_chat_update;
	TLS->callback.msg_receive = tw_msg_receive;
	TLS->callback.our_id = tw_our_id;
	TLS->callback.notification = tw_notification;
	TLS->callback.user_status_update = tw_user_status_update;
//FIXME: Right now we don't have a good name creation method. Let the default method generate names for now. :)
//	TLS->callback.create_print_name = tw_create_print_name;
}

void
tw_init (struct tgl_state* TLS)
{
	assert (TLS);
	_tw_read_configs (TLS);
	tgl_init (TLS);
}
