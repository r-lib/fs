#include "getmode.h"

unsigned short getmode__(const char* mode_str, unsigned short mode);

std::string strmode__(unsigned short mode);

std::string file_code__(const std::string& path, unsigned short mode);

extern "C" SEXP getmode_(SEXP mode_str_sxp, SEXP mode_sxp) {
  const char* mode_str = CHAR(STRING_ELT(mode_str_sxp, 0));
  unsigned short mode = INTEGER(mode_sxp)[0];
  unsigned short res = getmode__(mode_str, mode);

  return Rf_ScalarInteger(res);
}

extern "C" SEXP strmode_(SEXP mode_sxp) {
  unsigned short mode = INTEGER(mode_sxp)[0];
  SEXP out;

  BEGIN_CPP

  std::string res = strmode__(mode);
  out = Rf_mkString(res.c_str());

  END_CPP

  return out;
}

extern "C" SEXP file_code_(SEXP path_sxp, SEXP mode_sxp) {

  SEXP out;

  BEGIN_CPP

  std::string path(CHAR(STRING_ELT(path_sxp, 0)));
  unsigned short mode = INTEGER(mode_sxp)[0];

  std::string res = file_code__(path, mode);

  out = Rf_mkString(res.c_str());

  END_CPP

  return out;
}
