dnl Process this file with autoconf to produce a configure script.

AC_INIT(GTK+ gram, 0.0.0)
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([1.11 no-dist-gzip dist-xz foreign])
AM_SILENT_RULES([yes])
AM_MAINTAINER_MODE
GNOME_MAINTAINER_MODE_DEFINES

AM_PROG_VALAC([0.24])
AM_PROG_CC_C_O

AC_PATH_PROG(GLIB_COMPILE_RESOURCES, glib-compile-resources)

GLIB_GSETTINGS

dnl ###########################################################################
dnl Dependencies
dnl ###########################################################################

GLIB_REQUIRED=2.40.0
GTK_REQUIRED=3.11.6

PKG_CHECK_MODULES(GTKGRAM, [
    gtk+-3.0 >= $GTK_REQUIRED
    glib-2.0 >= $GLIB_REQUIRED
])

dnl ###########################################################################
dnl Internationalization
dnl ###########################################################################

AC_SUBST(GETTEXT_PACKAGE, GTK+gram)

dnl ###########################################################################
dnl Documentation
dnl ###########################################################################

YELP_HELP_INIT

dnl ###########################################################################
dnl Installed tests
dnl ###########################################################################
BEHAVE_INSTALLED_TESTS

dnl ###########################################################################
dnl Files to generate
dnl ###########################################################################

AC_OUTPUT([
Makefile
data/Makefile
src/Makefile
])
