bin_PROGRAMS = gtkgram

AM_CPPFLAGS= \
	     -DVERSION=\""$(VERSION)"\" \
	     -DGETTEXT_PACKAGE=\"$(GETTEXT_PACKAGE)\" \
	     -w \
	     $(GTKGRAM_CFLAGS)

BUILT_SOURCES = resources.c

resources.c: $(top_srcdir)/data/gtkgram.gresource.xml $(shell $(GLIB_COMPILE_RESOURCES) --generate-dependencies --sourcedir=$(top_srcdir)/data $(top_srcdir)/data/gtkgram.gresource.xml)
	$(AM_V_GEN) $(GLIB_COMPILE_RESOURCES) --target=$@ --sourcedir=$(top_srcdir)/data/ --generate-source $<

gtkgram_SOURCES = \
		  libevent.vapi\
		  tgl.vapi\
		  config.vapi\
		  about.vala\
		  chat-box.vala\
		  chat-list.vala\
		  chat-manager.vala\
		  chat-message.vala\
		  chat.vala\
		  gtkgram.vala\
	  	  main-window.vala\
		  ui_strings.vala\
		  login-assistant.vala\
		  message.vala\
		  class-converter.vala\
		  tgl-wrapper.c\
		  $(BUILT_SOURCES)

gtkgram_VALAFLAGS = \
		    --target-glib 2.32\
		    --pkg gtk+-3.0\
		    --pkg libnotify

gtkgram_LDADD = \
		$(GTKGRAM_LIBS)\
		$(top_srcdir)/tgl/libs/libtgl.a\
		-lz\
		-lm\
	     	-ldl\
	       	-lssl\
		-lcrypto\
		-levent\
		-lnotify

tgl/libs/libtgl.a:tgl/Makefile
	cd $(top_srcdir)/tgl; make

tgl/Makefile:tgl/Makefile.in tgl/configure
	cd $(top_srcdir)/tgl; ./configure --enable-libevent
