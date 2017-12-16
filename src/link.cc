#include "Rcpp.h"
#include "utils.h"
#include "uv.h"

using namespace Rcpp;

// [[Rcpp::export]]
void link_create_hard_(CharacterVector path, CharacterVector new_path) {
  for (size_t i = 0; i < Rf_xlength(new_path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    const char* n = CHAR(STRING_ELT(new_path, i));
    int res = uv_fs_link(uv_default_loop(), &req, p, n, NULL);
    stop_for_error("Failed to link", p, res);
    uv_fs_req_cleanup(&req);
  }
}

// [[Rcpp::export]]
void link_create_symbolic_(CharacterVector path, CharacterVector new_path) {
  for (size_t i = 0; i < Rf_xlength(new_path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    const char* n = CHAR(STRING_ELT(new_path, i));

    // TODO: investigate flags parameter on windows
    int res = uv_fs_symlink(uv_default_loop(), &req, p, n, 0, NULL);
    stop_for_error("Failed to link", p, res);
    uv_fs_req_cleanup(&req);
  }
}

// [[Rcpp::export]]
CharacterVector readlink_(CharacterVector path) {
  CharacterVector out(Rf_xlength(path));
  Rf_setAttrib(out, R_NamesSymbol, path);
  for (size_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    int res = uv_fs_readlink(uv_default_loop(), &req, p, NULL);
    SET_STRING_ELT(out, i, Rf_mkChar((const char*)req.ptr));
    stop_for_error("Failed to read link", p, res);
    uv_fs_req_cleanup(&req);
  }
  return out;
}
