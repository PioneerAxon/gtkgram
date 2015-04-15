bin_PROGRAMS = gtkgram

AM_CPPFLAGS= \
	     -w \
	     $(GTKGRAM_CFLAGS)

gtkgram_SOURCES = \
		  about.vala\
		  chat-box.vala\
		  chat-list.vala\
		  chat-manager.vala\
		  chat.vala\
		  gtkgram.vala\
	  	  main-window.vala\
		  tgl.vapi\
		  ui_strings.vala

gtkgram_VALAFLAGS = \
		    --target-glib 2.32\
		    --pkg gtk+-3.0

gtkgram_LDADD = \
		$(GTKGRAM_LIBS)\
		tgl/libs/libtgl.a\
		-lz\
		-lm\
	     	-ldl\
	       	-lssl\
	       	-lcrypto

