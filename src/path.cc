#include "uv.h"

#undef ERROR

#include "Rcpp.h"
#include "error.h"

using namespace Rcpp;

// [[Rcpp::export]]
CharacterVector normalize_(CharacterVector path) {
  CharacterVector out = CharacterVector(path.size());

  for (R_xlen_t i = 0; i < Rf_xlength(out); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    uv_fs_realpath(uv_default_loop(), &req, p, NULL);
    stop_for_error(req, "Failed to normalize '%s'", p);
    SET_STRING_ELT(out, i, Rf_mkChar((const char*)req.ptr));
    uv_fs_req_cleanup(&req);
  }
  return out;
}
// [[Rcpp::export]]
CharacterVector path_(List paths, const char* ext) {
  R_xlen_t max_row = 0;
  R_xlen_t max_col = Rf_xlength(paths);
  char buf[1024];
  char* b = buf;
  for (R_xlen_t c = 0; c < max_col; ++c) {
    R_xlen_t len = Rf_xlength(VECTOR_ELT(paths, c));
    if (len > max_row) {
      max_row = len;
    }
  }
  CharacterVector out(max_row);
  for (R_xlen_t r = 0; r < max_row; ++r) {
    bool has_na = false;
    b = buf;
    for (R_xlen_t c = 0; c < max_col; ++c) {
      R_xlen_t k = Rf_xlength(VECTOR_ELT(paths, c));
      if (k > 0) {
        SEXP str = STRING_ELT(VECTOR_ELT(paths, c), r % k);
        if (str == NA_STRING) {
          has_na = true;
          break;
        }
        const char* s = Rf_translateCharUTF8(str);
        strcpy(b, s);
        b += strlen(s);
        if (c != (max_col - 1)) {
          *b++ = '/';
        }
      }
    }
    if (has_na) {
      out[r] = NA_STRING;
    } else {
      if (strlen(ext) > 0) {
        *b++ = '.';
        strcpy(b, ext);
        b += strlen(ext) + 1;
      }
      out[r] = buf;
    }
  }
  return out;
}
