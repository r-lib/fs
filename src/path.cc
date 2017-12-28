#include "uv.h"

#undef ERROR

#include "Rcpp.h"
#include "error.h"

using namespace Rcpp;

// [[Rcpp::export]]
CharacterVector normalize_(CharacterVector path) {
  CharacterVector out = CharacterVector(path.size());

  for (R_len_t i = 0; i < Rf_xlength(out); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    uv_fs_realpath(uv_default_loop(), &req, p, NULL);
    stop_for_error(req, "Failed to normalize '%s'", p);
    SET_STRING_ELT(out, i, Rf_mkChar((const char*)req.ptr));
    uv_fs_req_cleanup(&req);
  }
  return out;
}
