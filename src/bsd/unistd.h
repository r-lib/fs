/* clang-format off */
/*
 * Copyright © 2006 Robert Millan
 * Copyright © 2008-2011 Guillem Jover <guillem@hadrons.org>
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef LIBBSD_OVERLAY
#include_next <unistd.h>
#else
#include <unistd.h>
#endif

#ifndef LIBBSD_UNISTD_H
#define LIBBSD_UNISTD_H

#include "bsd/cdefs.h"
#include <sys/stat.h>

#ifndef S_ISTXT
#define S_ISTXT S_ISVTX
#endif

__BEGIN_DECLS
extern int optreset;

#ifdef LIBBSD_OVERLAY
#undef getopt
#define getopt(argc, argv, optstr) bsd_getopt(argc, argv, optstr)
#endif

int bsd_getopt(int argc, char * const argv[], const char *shortopts);

mode_t getmode(const void *set, mode_t mode);
void *setmode(const char *mode_str);

#if defined (__DragonFly__)
int closefrom(int lowfd);
#else
void closefrom(int lowfd);
#endif

/* Compatibility with sendmail implementations. */
#define initsetproctitle(c, a, e) setproctitle_init((c), (a), (e))

void setproctitle_init(int argc, char *argv[], char *envp[]);
void setproctitle(const char *fmt, ...);

__END_DECLS

#endif
