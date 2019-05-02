#include "getmode.h"
#include "uv.h"

#undef ERROR

#include "CollectorList.h"
#include "Rcpp.h"
#include "error.h"
#include "utils.h"

using namespace Rcpp;

// [[Rcpp::export]]
void mkdir_(CharacterVector path, unsigned short mode) {
  R_xlen_t n = Rf_xlength(path);
  for (R_xlen_t i = 0; i < n; ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));

    int fd = uv_fs_mkdir(uv_default_loop(), &req, p, mode, NULL);

    if (fd == UV_EEXIST) {
      // Fail silently if the directory already exists

      uv_dirent_type_t t = get_dirent_type(p);
      if (t == UV_DIRENT_DIR || t == UV_DIRENT_LINK) {
        uv_fs_req_cleanup(&req);
        continue;
      }
    } else if (fd == UV_EPERM && i < n - 1) {
      // Fail silently if we do not have permissions to create the directory and
      // it is not the last directory we are trying to create. (In this case we
      // assume the directory already exists).

      uv_fs_req_cleanup(&req);
      continue;
    }

    stop_for_error(req, "Failed to make directory '%s'", p);
  }
}

// [[Rcpp::export]]
void rmdir_(CharacterVector path) {
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    uv_fs_rmdir(uv_default_loop(), &req, p, NULL);
    stop_for_error(req, "Failed to remove '%s'", p);

    uv_fs_req_cleanup(&req);
  }
}

void dir_map(
    Function fun,
    const char* path,
    bool all,
    int file_type,
    size_t recurse,
    CollectorList* value,
    bool fail) {
  uv_fs_t req;
  uv_fs_scandir(uv_default_loop(), &req, path, 0, NULL);

  if (!fail && warn_for_error(req, "Failed to search directory '%s'", path)) {
    return;
  }

  stop_for_error(req, "Failed to search directory '%s'", path);

  uv_dirent_t e;
  for (int next_res = uv_fs_scandir_next(&req, &e); next_res != UV_EOF;
       next_res = uv_fs_scandir_next(&req, &e)) {
    if (!all && e.name[0] == '.') {
      continue;
    }

    std::string name;

    // If path is '.', just return the name
    if (strcmp(path, ".") == 0) {
      name = e.name;
    }
    // If path already ends with '/' just concatenate them.
    else if (path[strlen(path) - 1] == '/') {
      name = std::string(path) + e.name;
    } else {
      name = std::string(path) + '/' + e.name;
    }
    uv_dirent_type_t entry_type = get_dirent_type(name.c_str(), e.type);
    if (file_type == -1 || (((1 << (entry_type)) & file_type) > 0)) {
      value->push_back(fun(asCharacterVector(name)));
    }

    if (recurse > 0 && entry_type == UV_DIRENT_DIR) {
      dir_map(fun, name.c_str(), all, file_type, recurse - 1, value, fail);
    }
    if (next_res != UV_EOF) {

      if (!fail && warn_for_error(req, "Failed to open directory '%s'", path)) {
        continue;
      }
      stop_for_error(req, "Failed to open directory '%s'", path);
    }
  }
  uv_fs_req_cleanup(&req);
}

// [[Rcpp::export]]
List dir_map_(
    CharacterVector path,
    Function fun,
    bool all,
    IntegerVector type,
    size_t recurse,
    bool fail) {
  int file_type = INTEGER(type)[0];

  CollectorList out;
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    const char* p = CHAR(STRING_ELT(path, i));
    dir_map(fun, p, all, file_type, recurse, &out, fail);
  }
  return out.vector();
}
