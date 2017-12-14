#include "Rcpp.h"
#include "utils.h"
#include "uv.h"

using namespace Rcpp;

// [[Rcpp::export]]
void move_(CharacterVector path, CharacterVector new_path) {
  for (size_t i = 0; i < Rf_xlength(new_path); ++i) {
    uv_fs_t file_req;
    const char* p = CHAR(STRING_ELT(path, i));
    const char* n = CHAR(STRING_ELT(new_path, i));
    int res = uv_fs_rename(uv_default_loop(), &file_req, p, n, NULL);
    stop_for_error(p, res);
    uv_fs_req_cleanup(&file_req);
  }
}
