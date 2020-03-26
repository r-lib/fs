#include "getmode.h"
#include "uv.h"

#undef ERROR

#include "CollectorList.h"
#include "Rinternals.h"
#include "error.h"
#include "utils.h"

// [[export]]
extern "C" SEXP mkdir_(SEXP path, SEXP mode_sxp) {
  unsigned short mode = INTEGER(mode_sxp)[0];

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

  return R_NilValue;
}

// [[export]]
extern "C" SEXP rmdir_(SEXP path) {
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    uv_fs_rmdir(uv_default_loop(), &req, p, NULL);
    stop_for_error(req, "Failed to remove '%s'", p);

    uv_fs_req_cleanup(&req);
  }

  return R_NilValue;
}

void dir_map(
    SEXP fun,
    const char* path,
    bool all,
    int file_type,
    int recurse,
    CollectorList* value,
    bool fail) {

  if (recurse < 0) {
    recurse = std::numeric_limits<int>::max();
  }

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
    uv_dirent_type_t entry_type = get_dirent_type(name.c_str(), e.type, fail);
    if (file_type == -1 || (((1 << (entry_type)) & file_type) > 0)) {
      value->push_back(
          Rf_eval(Rf_lang2(fun, Rf_mkString(name.c_str())), R_GlobalEnv));
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

// [[export]]
extern "C" SEXP dir_map_(
    SEXP path_sxp,
    SEXP fun_sxp,
    SEXP all_sxp,
    SEXP type_sxp,
    SEXP recurse_sxp,
    SEXP fail_sxp) {

  CollectorList out;
  for (R_xlen_t i = 0; i < Rf_xlength(path_sxp); ++i) {
    const char* p = CHAR(STRING_ELT(path_sxp, i));
    dir_map(
        fun_sxp,
        p,
        LOGICAL(all_sxp)[0],
        INTEGER(type_sxp)[0],
        INTEGER(recurse_sxp)[0],
        &out,
        LOGICAL(fail_sxp)[0]);
  }
  return out.vector();
}
