#include "uv.h"

#undef ERROR

#include "Rinternals.h"
#include "error.h"
#include "utils.h"

// [[export]]
extern "C" SEXP link_create_hard_(SEXP path, SEXP new_path) {
  for (R_xlen_t i = 0; i < Rf_xlength(new_path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    const char* n = CHAR(STRING_ELT(new_path, i));
    uv_fs_link(uv_default_loop(), &req, p, n, NULL);
    stop_for_error2(req, "Failed to link '%s' to '%s'", p, n);
    uv_fs_req_cleanup(&req);
  }

  return R_NilValue;
}

// [[export]]
extern "C" SEXP link_create_symbolic_(SEXP path, SEXP new_path) {
  for (R_xlen_t i = 0; i < Rf_xlength(new_path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    const char* n = CHAR(STRING_ELT(new_path, i));

    int flags = 0;
// windows 10 sort of supports file links for non-elevated users, and libuv
// will try the flag, https://github.com/libuv/libuv/issues/1157. But most
// users do not _yet_ have this enabled. In the meantime we will always use
// the directory symlinks instead.
#ifdef __WIN32
    flags = UV_FS_SYMLINK_JUNCTION;
#endif
    uv_fs_symlink(uv_default_loop(), &req, p, n, flags, NULL);
    if (req.result == UV_EEXIST && get_dirent_type(n) == UV_DIRENT_LINK) {
      // check that the link points to where we want to point to
      uv_fs_t l_req;
      uv_fs_readlink(uv_default_loop(), &l_req, n, NULL);
      stop_for_error(l_req, "Failed to read link '%s'", n);
      if (strcmp(path_tidy_((const char*)l_req.ptr).c_str(), p) == 0) {
        uv_fs_req_cleanup(&req);
        uv_fs_req_cleanup(&l_req);
        continue;
      }
      uv_fs_req_cleanup(&l_req);
    }
    stop_for_error2(req, "Failed to link '%s' to '%s'", p, n);
    uv_fs_req_cleanup(&req);
  }

  return R_NilValue;
}

// [[export]]
extern "C" SEXP readlink_(SEXP path) {
  SEXP out = PROTECT(Rf_allocVector(STRSXP, Rf_xlength(path)));
  Rf_setAttrib(out, R_NamesSymbol, path);
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    uv_fs_readlink(uv_default_loop(), &req, p, NULL);
    stop_for_error(req, "Failed to read link '%s'", p);
    SET_STRING_ELT(out, i, Rf_mkCharCE((const char*)req.ptr, CE_UTF8));
    uv_fs_req_cleanup(&req);
  }

  UNPROTECT(1);
  return out;
}
