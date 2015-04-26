#ifndef __TGL_WRAPPER_H__
#define __TGL_WRAPPER_H__

#include "../tgl/tgl.h"

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


#endif
