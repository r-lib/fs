#include "error.h"

#define BUFSIZE 8192

SEXP error_condition(uv_fs_t req, const char* loc, const char* format, ...) {
  SEXP condition, c, signalConditionFun, out;
  va_list ap;

  if (req.result >= 0) {
    return R_NilValue;
  }
  int err = req.result;
  uv_fs_req_cleanup(&req);

  const char* nms[] = {"message", ""};
  PROTECT(condition = Rf_mkNamed(VECSXP, nms));

  PROTECT(c = Rf_allocVector(STRSXP, 4));
  SET_STRING_ELT(c, 0, Rf_mkChar(uv_err_name(err)));
  SET_STRING_ELT(c, 1, Rf_mkChar("fs_error"));
  SET_STRING_ELT(c, 2, Rf_mkChar("error"));
  SET_STRING_ELT(c, 3, Rf_mkChar("condition"));

  char buf[BUFSIZE];
  size_t length = 0;
  length += snprintf(buf + length, BUFSIZE - length, "[%s] ", uv_err_name(err));
  va_start(ap, format);
  length += vsnprintf(buf + length, BUFSIZE - length, format, ap);
  va_end(ap);
  snprintf(buf + length, BUFSIZE - length, ": %s", uv_strerror(err));

  SET_VECTOR_ELT(condition, 0, Rf_mkString(buf));
  Rf_setAttrib(condition, R_ClassSymbol, c);
  Rf_setAttrib(condition, Rf_mkString("location"), Rf_mkString(loc));
  signalConditionFun = Rf_findFun(Rf_install("stop"), R_BaseEnv);

  SEXP call = PROTECT(Rf_lang2(signalConditionFun, condition));
  PROTECT(out = Rf_eval(call, R_GlobalEnv));

  UNPROTECT(4);

  return out;
}
