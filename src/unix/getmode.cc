#include "getmode.h"

#if (defined(__APPLE__) && defined(__MACH__)) || defined(__OpenBSD__) ||       \
    defined(__FreeBSD__) || defined(__NetBSD__)
#include <string.h> /* for strmode */
#include <unistd.h> /* for getmode / setmode */
#else
#include "bsd/string.h" /* for strmode */
#include "bsd/unistd.h" /* for getmode / setmode */
#endif

#include <Rcpp.h> /* for Rf_error */

#include <sys/stat.h>

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

unsigned short getmode__(const char* mode_str, unsigned short mode) {
  void* out = setmode(mode_str);
  if (out == NULL) {
    // TODO: use stop_for_error here
    Rf_error("Invalid mode '%s'", mode_str);
  }
  mode_t res = getmode(out, mode);
  free(out);
  return res;
}

std::string strmode__(unsigned short mode) {
  char out[12];
  strmode(mode, out);

  // The last character is always a space, we will set it to NUL
  out[10] = '\0';

  // The first character is the file type, so we skip it.
  return out + 1;
}

std::string file_code__(const std::string& path, unsigned short mode) {
  switch (mode & S_IFMT) {
  case S_IFDIR:
    if (mode & S_IWOTH)
      if (mode & S_ISTXT)
        return "tw";
      else
        return "ow";
    else
      return "di";
  case S_IFLNK:
    return "ln";
  case S_IFSOCK:
    return "so";
  case S_IFIFO:
    return "pi";
  case S_IFBLK:
    return "db";
  case S_IFCHR:
    return "cd";
  default:;
  }
  if (mode & (S_IXUSR | S_IXGRP | S_IXOTH)) {
    if (mode & S_ISUID)
      return "su";
    else if (mode & S_ISGID)
      return "sg";
    else
      return "ex";
  }
  return "";
}
