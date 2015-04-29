#ifndef __TGL_WRAPPER_H__
#define __TGL_WRAPPER_H__

#include "../tgl/tgl.h"

#define DC_SERIALIZED_MAGIC 0x868aa81d

char* DOWNLOAD_PATH;
char* BASE_DIR_PATH;
char* AUTH_FILE_PATH;

typedef void (*tw_login_init) (struct tgl_state* TLS);
typedef void (*tw_login_get_phone) (struct tgl_state* TLS);
typedef void (*tw_login_get_name) (struct tgl_state* TLS);
typedef void (*tw_login_get_otp) (struct tgl_state* TLS);
typedef void (*tw_login_destroy) (struct tgl_state* TLS);

void tw_init (struct tgl_state* TLS);

void tw_register_login_init (struct tgl_state* TLS, tw_login_init login_init_func);

void tw_register_login_get_phone (struct tgl_state* TLS, tw_login_get_phone login_phone_func);
void tw_login_set_phone_number (struct tgl_state* TLS, char* phone);

void tw_register_login_get_name (struct tgl_state* TLS, tw_login_get_name login_name_func);
void tw_login_set_name (struct tgl_state* TLS, char* firstname, char* lastname);

void tw_register_login_get_otp (struct tgl_state* TLS, tw_login_get_otp login_otp_func);
void tw_login_set_otp_call (struct tgl_state* TLS);
void tw_login_set_otp (struct tgl_state* TLS, char* otp);

void tw_register_login_destroy (struct tgl_state* TLS, tw_login_destroy login_destroy_func);



typedef void (*tw_callback_logged_in) (struct tgl_state* TLS, void* data);
typedef void (*tw_callback_started) (struct tgl_state* TLS, void* data);
typedef void (*tw_callback_msg_receive) (struct tgl_message* M, void* data);

void tw_register_callback_logged_in (struct tgl_state* TLS, tw_callback_logged_in func, void* data);
void tw_register_callback_started (struct tgl_state* TLS, tw_callback_started func, void* data);
void tw_register_callback_msg_receive (struct tgl_state* TLS, tw_callback_msg_receive func, void* data);

#endif
