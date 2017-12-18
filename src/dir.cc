#if defined(__APPLE__) && defined(__MACH__)
#include <string.h>
#include <unistd.h>
#else
#include <bsd/string.h>
#include <bsd/unistd.h>
#endif

#include "Rcpp.h"
#include "utils.h"
#include "uv.h"

using namespace Rcpp;

// [[Rcpp::export]]
void mkdir_(CharacterVector path, std::string mode_str) {
  void* out = setmode(mode_str.c_str());
  mode_t mode = getmode(out, 0);

  for (size_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    int fd = uv_fs_mkdir(uv_default_loop(), &req, p, mode, NULL);
    stop_for_error("Failed to make directory", p, fd);
    uv_fs_req_cleanup(&req);
  }
}

// [[Rcpp::export]]
List scandir_(CharacterVector path) {
  // TODO: filter by file type
  // TODO: filter by name / pattern
  //
  List out = List(Rf_xlength(path));
  Rf_setAttrib(out, R_NamesSymbol, Rf_duplicate(path));

  for (size_t i = 0; i < Rf_xlength(path); ++i) {
    std::vector<std::string> files;
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    int res = uv_fs_scandir(uv_default_loop(), &req, p, 0, NULL);
    stop_for_error("Failed to search directory", p, res);

    uv_dirent_t d;
    int next_res = res;
    while (next_res != UV_EOF) {
      next_res = uv_fs_scandir_next(&req, &d);
      files.push_back(d.name);
      if (next_res != UV_EOF) {
        stop_for_error("Failed to search directory", p, next_res);
      }
    }
    SET_VECTOR_ELT(out, i, wrap(files));

    uv_fs_req_cleanup(&req);
  }
  return out;
}
