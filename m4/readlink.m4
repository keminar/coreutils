# readlink.m4 serial 7
dnl Copyright (C) 2003, 2007, 2009 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_READLINK],
[
  AC_REQUIRE([gl_UNISTD_H_DEFAULTS])
  AC_CHECK_FUNCS_ONCE([readlink])
  if test $ac_cv_func_readlink = no; then
    HAVE_READLINK=0
    AC_LIBOBJ([readlink])
    gl_PREREQ_READLINK
  else
    AC_CACHE_CHECK([whether readlink signature is correct],
      [gl_cv_decl_readlink_works],
      [AC_COMPILE_IFELSE(
         [AC_LANG_PROGRAM(
           [[#include <unistd.h>
      /* Cause compilation failure if original declaration has wrong type.  */
      ssize_t readlink (const char *, char *, size_t);]])],
         [gl_cv_decl_readlink_works=yes], [gl_cv_decl_readlink_works=no])])
    AC_CACHE_CHECK([whether readlink handles trailing slash correctly],
      [gl_cv_func_readlink_works],
      [# We have readlink, so assume ln -s works.
       ln -s conftest.no-such conftest.link
       AC_RUN_IFELSE(
         [AC_LANG_PROGRAM(
           [[#include <unistd.h>
]], [[char buf[20];
      return readlink ("conftest.link/", buf, sizeof buf) != -1;]])],
         [gl_cv_func_readlink_works=yes], [gl_cv_func_readlink_works=no],
         [gl_cv_func_readlink_works="guessing no"])
      rm -f conftest.link])
    if test "$gl_cv_func_readlink_works" != yes; then
      AC_DEFINE([READLINK_TRAILING_SLASH_BUG], [1], [Define to 1 if readlink
        fails to recognize a trailing slash.])
      REPLACE_READLINK=1
      AC_LIBOBJ([readlink])
    elif test "$gl_cv_decl_readlink_works" != yes; then
      REPLACE_READLINK=1
      AC_LIBOBJ([readlink])
    fi
  fi
])

# Like gl_FUNC_READLINK, except prepare for separate compilation (no AC_LIBOBJ).
AC_DEFUN([gl_FUNC_READLINK_SEPARATE],
[
  AC_CHECK_FUNCS_ONCE([readlink])
  gl_PREREQ_READLINK
])

# Prerequisites of lib/readlink.c.
AC_DEFUN([gl_PREREQ_READLINK],
[
  :
])
