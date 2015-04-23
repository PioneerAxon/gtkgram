#include "../tgl/tgl-binlog.h"
#include <assert.h>

#define TEST_SERVER "149.154.167.40"
#define PROD_SERVER "149.154.167.50"

void
tw_get_string (struct tgl_state* TLS, const char* prompt, int flags, void (*callback) (struct tgl_state* TLS, char* string, void* arg), void *arg)
{
}

static void
_tw_read_configs (struct tgl_state* TLS)
{
	assert (TLS);
	bl_do_dc_option (TLS, 1, 0, "", strlen (TEST_SERVER), TEST_SERVER, 443);
	bl_do_dc_option (TLS, 2, 0, "", strlen (PROD_SERVER), PROD_SERVER, 443);
	bl_do_set_working_dc (TLS, 1);
	bl_do_reset_authorization (TLS);
	TLS->callback.get_string = tw_get_string;
}

void
tw_init (struct tgl_state* TLS)
{
	assert (TLS);
	_tw_read_configs (TLS);
	tgl_init (TLS);
}
