#include "Rcpp.h"
#include "utils.h"
#include "uv.h"

// [[Rcpp::export]]
CharacterVector realpath_(CharacterVector path) {
  CharacterVector out = CharacterVector(path.size());

  for (size_t i = 0; i < Rf_xlength(out); ++i) {
    uv_fs_t file_req;
    const char* p = CHAR(STRING_ELT(path, i));
    int res = uv_fs_realpath(uv_default_loop(), &file_req, p, NULL);
    stop_for_error(p, res);
    SET_STRING_ELT(out, i, Rf_mkChar((const char*)file_req.ptr));
    uv_fs_req_cleanup(&file_req);
  }
  return out;
}
