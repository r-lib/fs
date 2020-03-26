#include "getmode.h"
#include <sys/stat.h>

#include <Rinternals.h> /* for Rf_error */

extern "C" SEXP getmode_(SEXP mode_str_sxp, SEXP mode_sxp) {
  const char* mode_str = CHAR(STRING_ELT(mode_str_sxp, 0));
  unsigned short mode = INTEGER(mode_sxp)[0];
  unsigned short res = getmode__(mode_str, mode);

  return Rf_ScalarInteger(res);
}

extern "C" SEXP strmode_(SEXP mode_sxp) {
  unsigned short mode = INTEGER(mode_sxp)[0];
  std::string res = strmode__(mode);

  return Rf_mkString(res.c_str());
}

extern "C" SEXP file_code_(SEXP path_sxp, SEXP mode_sxp) {
  std::string path(CHAR(STRING_ELT(path_sxp, 0)));
  unsigned short mode = INTEGER(mode_sxp)[0];

  std::string res = file_code__(path, mode);

  return Rf_mkString(res.c_str());
}

/* code adapted from https://cgit.freedesktop.org/libbsd/tree/src/setmode.c */
unsigned short getmode__(const char* mode_str, unsigned short mode) {
  const char* p = mode_str;
  char* ep;
  char op;
  mode_t perm, who, out;
  long lval;

  p = mode_str;
  perm = who = out = 0;

  /*
   * If an absolute number, get it and return; disallow non-octal digits
   * or illegal bits.
   */
  if (isdigit((unsigned char)*p)) {
    errno = 0;
    lval = strtol(p, &ep, 8);
    if (*ep) {
      Rf_error("Invalid mode '%s'", mode_str);
    }
    if (errno == ERANGE && (lval == LONG_MAX || lval == LONG_MIN)) {
      Rf_error("Invalid mode '%s'", mode_str);
    }
    perm = (mode_t)lval;
    who = S_IRWXU;
    op = '=';
    goto apply;
  }
  /* First, find out which bits might be modified. */
  for (;; ++p) {
    switch (*p) {
    case 'a':
    case 'u':
      who |= S_IRWXU;
      break;
    default:
      goto getop;
    }
  }

getop:
  if ((op = *p++) != '+' && op != '-' && op != '=') {
    errno = EINVAL;
    Rf_error("Invalid mode '%s'", mode_str);
  }
  for (perm = 0;; ++p) {
    switch (*p) {
    case 'r':
      perm |= S_IRUSR;
      break;
    case 'w':
      perm |= S_IWUSR;
      break;
    case 'x':
      perm |= S_IXUSR;
      break;
    default:
      goto apply;
    }
  }
apply:
  switch (op) {
  case '=':
    out = perm;
    break;
  case '+':
    out = mode | perm;
    break;
  case '-':
    out = mode & ~perm;
    break;
  default:
    Rf_error("Invalid mode '%s'", mode_str);
  }
  out &= who;
  errno = 0;
  return out;
}

#if defined(LIBC_SCCS) && !defined(lint)
static char sccsid[] = "@(#)strmode.c	8.3 (Berkeley) 8/15/94";
#endif /* LIBC_SCCS and not lint */
#include <sys/cdefs.h>

#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

/* Adapted from
 * https://cgit.freedesktop.org/libbsd/plain/src/strmode.c?id=8dbfb3529b0253ba8067042dabaebe3ad89cb039
 */
/*-
 * Copyright (c) 1990, 1993
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */
void strmode(mode_t mode, char* p) {
  /* print type */
  switch (mode & S_IFMT) {
  case S_IFDIR: /* directory */
    *p++ = 'd';
    break;
  case S_IFCHR: /* character special */
    *p++ = 'c';
    break;
  case S_IFBLK: /* block special */
    *p++ = 'b';
    break;
  case S_IFREG: /* regular */
    *p++ = '-';
    break;
  default: /* unknown */
    *p++ = '?';
    break;
  }
  /* usr */
  if (mode & S_IRUSR)
    *p++ = 'r';
  else
    *p++ = '-';
  if (mode & S_IWUSR)
    *p++ = 'w';
  else
    *p++ = '-';
  switch (mode & (S_IXUSR)) {
  case 0:
    *p++ = '-';
    break;
  case S_IXUSR:
    *p++ = 'x';
    break;
  }
  *p++ = ' '; /* will be a '+' if ACL's implemented */
  *p = '\0';
}

std::string strmode__(mode_t mode) {
  char out[4];
  strmode(mode, out);

  // The first character is the file type, so we do not return it.
  return out + 1;
}
#define S_IFLNK 0120000

std::string file_code__(std::string path, mode_t mode) {
  switch (mode & S_IFMT) {
  case S_IFDIR:
    return "di";
  case S_IFLNK:
    return "ln";
  case S_IFIFO:
    return "pi";
  case S_IFBLK:
    return "db";
  case S_IFCHR:
    return "cd";
  default:;
  }
  if (mode & S_IXUSR) {
    return "ex";
  }
  return "";
}
