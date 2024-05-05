#ifndef __STDC_FORMAT_MACROS
#define __STDC_FORMAT_MACROS 1
#endif

#include <string>
#include <vector>
#include <inttypes.h>

#include "error.h"

#ifndef __WIN32
#include <grp.h>
#include <pwd.h>
#endif

#include <Rinternals.h>

#include "getmode.h"
#include "uv.h"

#undef ERROR

// [[export]]
extern "C" SEXP fs_move_(SEXP path, SEXP new_path) {
  for (R_xlen_t i = 0; i < Rf_xlength(new_path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    const char* n = CHAR(STRING_ELT(new_path, i));
    int res = uv_fs_rename(uv_default_loop(), &req, p, n, NULL);

    // Rename does not work across partitions, so we need to instead copy, then
    // remove the file.
    if (res == UV_EXDEV) {
      uv_fs_req_cleanup(&req);

      uv_fs_copyfile(uv_default_loop(), &req, p, n, 0, NULL);
      stop_for_error2(req, "Failed to copy '%s' to '%s'", p, n);
      uv_fs_req_cleanup(&req);

      uv_fs_unlink(uv_default_loop(), &req, p, NULL);
      stop_for_error(req, "Failed to remove '%s'", p);
      uv_fs_req_cleanup(&req);
      continue;
    }

    stop_for_error2(req, "Failed to move '%s' to '%s'", p, n);
    uv_fs_req_cleanup(&req);
  }

  return R_NilValue;
}

// [[export]]
extern "C" SEXP fs_create_(SEXP path_sxp, SEXP mode_sxp) {

  unsigned short mode = INTEGER(mode_sxp)[0];

  for (R_xlen_t i = 0; i < Rf_xlength(path_sxp); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path_sxp, i));
    int fd = uv_fs_open(
        uv_default_loop(), &req, p, UV_FS_O_CREAT | UV_FS_O_WRONLY, mode, NULL);
    stop_for_error(req, "Failed to open '%s'", p);

    uv_fs_close(uv_default_loop(), &req, fd, NULL);
    stop_for_error(req, "Failed to close '%s'", p);

    uv_fs_req_cleanup(&req);
  }

  return R_NilValue;
}

// [[export]]
extern "C" SEXP fs_stat_(SEXP path, SEXP fail_sxp) {
  bool fail = LOGICAL(fail_sxp)[0];
  // typedef struct {
  //  uint64_t st_dev;
  //  uint64_t st_mode;
  //  uint64_t st_nlink;
  //  uint64_t st_uid;
  //  uint64_t st_gid;
  //  uint64_t st_rdev;
  //  uint64_t st_ino;
  //  uint64_t st_size;
  //  uint64_t st_blksize;
  //  uint64_t st_blocks;
  //  uint64_t st_flags;
  //  uint64_t st_gen;
  //  uv_timespec_t st_atim;
  //  uv_timespec_t st_mtim;
  //  uv_timespec_t st_ctim;
  //  uv_timespec_t st_birthtim;

  R_xlen_t n = Rf_xlength(path);

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 18));
  SEXP names = PROTECT(Rf_allocVector(STRSXP, 18));

  SET_STRING_ELT(names, 0, Rf_mkChar("path"));
  SET_VECTOR_ELT(out, 0, Rf_duplicate(path));

  SET_STRING_ELT(names, 1, Rf_mkChar("device_id"));
  SET_VECTOR_ELT(out, 1, Rf_allocVector(REALSXP, n));

  SET_STRING_ELT(names, 2, Rf_mkChar("type"));
  SET_VECTOR_ELT(out, 2, Rf_allocVector(INTSXP, n));

  SET_STRING_ELT(names, 3, Rf_mkChar("permissions"));
  SET_VECTOR_ELT(out, 3, Rf_allocVector(INTSXP, n));
  SEXP class_perm_sxp = PROTECT(Rf_allocVector(STRSXP, 2));
  SET_STRING_ELT(class_perm_sxp, 0, Rf_mkChar("fs_perms"));
  SET_STRING_ELT(class_perm_sxp, 1, Rf_mkChar("integer"));
  Rf_classgets(VECTOR_ELT(out, 3), class_perm_sxp);
  UNPROTECT(1);

  SET_STRING_ELT(names, 4, Rf_mkChar("hard_links"));
  SET_VECTOR_ELT(out, 4, Rf_allocVector(REALSXP, n));

  SET_STRING_ELT(names, 5, Rf_mkChar("user"));
  SET_VECTOR_ELT(out, 5, Rf_allocVector(STRSXP, n));

  SET_STRING_ELT(names, 6, Rf_mkChar("group"));
  SET_VECTOR_ELT(out, 6, Rf_allocVector(STRSXP, n));

  SET_STRING_ELT(names, 7, Rf_mkChar("special_device_id"));
  SET_VECTOR_ELT(out, 7, Rf_allocVector(REALSXP, n));

  SET_STRING_ELT(names, 8, Rf_mkChar("inode"));
  SET_VECTOR_ELT(out, 8, Rf_allocVector(REALSXP, n));

  SET_STRING_ELT(names, 9, Rf_mkChar("size"));
  SET_VECTOR_ELT(out, 9, Rf_allocVector(REALSXP, n));

  SEXP class_sxp = PROTECT(Rf_allocVector(STRSXP, 2));
  SET_STRING_ELT(class_sxp, 0, Rf_mkChar("fs_bytes"));
  SET_STRING_ELT(class_sxp, 1, Rf_mkChar("numeric"));
  Rf_classgets(VECTOR_ELT(out, 9), class_sxp);
  UNPROTECT(1);

  SET_STRING_ELT(names, 10, Rf_mkChar("block_size"));
  SET_VECTOR_ELT(out, 10, Rf_allocVector(REALSXP, n));

  SET_STRING_ELT(names, 11, Rf_mkChar("blocks"));
  SET_VECTOR_ELT(out, 11, Rf_allocVector(REALSXP, n));

  SET_STRING_ELT(names, 12, Rf_mkChar("flags"));
  SET_VECTOR_ELT(out, 12, Rf_allocVector(INTSXP, n));

  SET_STRING_ELT(names, 13, Rf_mkChar("generation"));
  SET_VECTOR_ELT(out, 13, Rf_allocVector(REALSXP, n));

  SET_STRING_ELT(names, 14, Rf_mkChar("access_time"));
  SET_VECTOR_ELT(out, 14, Rf_allocVector(REALSXP, n));

  SET_STRING_ELT(names, 15, Rf_mkChar("modification_time"));
  SET_VECTOR_ELT(out, 15, Rf_allocVector(REALSXP, n));

  SET_STRING_ELT(names, 16, Rf_mkChar("change_time"));
  SET_VECTOR_ELT(out, 16, Rf_allocVector(REALSXP, n));

  SET_STRING_ELT(names, 17, Rf_mkChar("birth_time"));
  SET_VECTOR_ELT(out, 17, Rf_allocVector(REALSXP, n));

  R_xlen_t i;
  for (i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    int res = uv_fs_lstat(uv_default_loop(), &req, p, NULL);

    bool is_na = STRING_ELT(path, i) == NA_STRING;
    bool doesnt_exist = res == UV_ENOENT || res == UV_ENOTDIR;
    bool has_error =
        !fail && !doesnt_exist && warn_for_error(req, "Failed to stat '%s'", p);

    if (is_na || doesnt_exist || has_error) {
      if (fail) {
        stop_for_error(req, "Failed to stat '%s'", p);
      } else {
        REAL(VECTOR_ELT(out, 1))[i] = NA_REAL;
        INTEGER(VECTOR_ELT(out, 2))[i] = NA_INTEGER;
        INTEGER(VECTOR_ELT(out, 2))[i] = NA_INTEGER;
        INTEGER(VECTOR_ELT(out, 3))[i] = NA_INTEGER;
        REAL(VECTOR_ELT(out, 4))[i] = NA_REAL;
        SET_STRING_ELT(VECTOR_ELT(out, 5), i, NA_STRING);
        SET_STRING_ELT(VECTOR_ELT(out, 6), i, NA_STRING);
        REAL(VECTOR_ELT(out, 7))[i] = NA_REAL;
        REAL(VECTOR_ELT(out, 8))[i] = NA_REAL;
        REAL(VECTOR_ELT(out, 9))[i] = NA_REAL;
        REAL(VECTOR_ELT(out, 10))[i] = NA_REAL;
        REAL(VECTOR_ELT(out, 11))[i] = NA_REAL;
        INTEGER(VECTOR_ELT(out, 12))[i] = NA_INTEGER;
        REAL(VECTOR_ELT(out, 13))[i] = NA_REAL;
        REAL(VECTOR_ELT(out, 14))[i] = NA_REAL;
        REAL(VECTOR_ELT(out, 15))[i] = NA_REAL;
        REAL(VECTOR_ELT(out, 16))[i] = NA_REAL;
        REAL(VECTOR_ELT(out, 17))[i] = NA_REAL;
        continue;
      }
    }
    stop_for_error(req, "Failed to stat '%s'", p);

    uv_stat_t st = req.statbuf;
    REAL(VECTOR_ELT(out, 1))[i] = st.st_dev;
    int type;
    switch (st.st_mode & S_IFMT) {
    case S_IFBLK:
      type = 0;
      break;
    case S_IFCHR:
      type = 1;
      break;
    case S_IFDIR:
      type = 2;
      break;
    case S_IFIFO:
      type = 3;
      break;
    case S_IFLNK:
      type = 4;
      break;
    case S_IFREG:
      type = 5;
      break;
#ifndef __WIN32
    case S_IFSOCK:
      type = 6;
      break;
#endif
    default:
      type = NA_INTEGER;
      break;
    }
    INTEGER(VECTOR_ELT(out, 2))[i] = type;
    INTEGER(VECTOR_ELT(out, 3))[i] = st.st_mode;
    REAL(VECTOR_ELT(out, 4))[i] = st.st_nlink;

#ifdef __WIN32
    SET_STRING_ELT(VECTOR_ELT(out, 5), i, NA_STRING);
#else
    passwd* pwd;
    if ((pwd = getpwuid(st.st_uid)) != NULL) {
      SET_STRING_ELT(VECTOR_ELT(out, 5), i, Rf_mkCharCE(pwd->pw_name, CE_UTF8));
    } else {
      char buf[20];
      snprintf(buf, sizeof(buf), "%" PRIu64, st.st_uid);
      SET_STRING_ELT(VECTOR_ELT(out, 5), i, Rf_mkCharCE(buf, CE_UTF8));
    }
#endif

#ifdef __WIN32
    SET_STRING_ELT(VECTOR_ELT(out, 6), i, NA_STRING);
#else
    group* grp;
    if ((grp = getgrgid(st.st_gid)) != NULL) {
      SET_STRING_ELT(VECTOR_ELT(out, 6), i, Rf_mkCharCE(grp->gr_name, CE_UTF8));
    } else {
      char buf[20];
      snprintf(buf, sizeof(buf), "%" PRIu64, st.st_gid);
      SET_STRING_ELT(VECTOR_ELT(out, 6), i, Rf_mkCharCE(buf, CE_UTF8));
    }
#endif

    REAL(VECTOR_ELT(out, 7))[i] = st.st_rdev;
    REAL(VECTOR_ELT(out, 8))[i] = st.st_ino;
    REAL(VECTOR_ELT(out, 9))[i] = st.st_size;
    REAL(VECTOR_ELT(out, 10))[i] = st.st_blksize;
    REAL(VECTOR_ELT(out, 11))[i] = st.st_blocks;
    INTEGER(VECTOR_ELT(out, 12))[i] = st.st_flags;
    REAL(VECTOR_ELT(out, 13))[i] = st.st_gen;

    REAL(VECTOR_ELT(out, 14))
    [i] = (st.st_atim.tv_sec + 1e-9 * st.st_atim.tv_nsec);

    REAL(VECTOR_ELT(out, 15))
    [i] = (st.st_mtim.tv_sec + 1e-9 * st.st_mtim.tv_nsec);

    REAL(VECTOR_ELT(out, 16))
    [i] = (st.st_ctim.tv_sec + 1e-9 * st.st_ctim.tv_nsec);

    REAL(VECTOR_ELT(out, 17))
    [i] = (st.st_birthtim.tv_sec + 1e-9 * st.st_birthtim.tv_nsec);
    uv_fs_req_cleanup(&req);
  }
  Rf_setAttrib(out, R_NamesSymbol, names);
  Rf_setAttrib(out, R_ClassSymbol, Rf_mkString("data.frame"));

  SEXP row_names = PROTECT(Rf_allocVector(INTSXP, 2));
  INTEGER(row_names)[0] = NA_INTEGER;
  INTEGER(row_names)[1] = -i;
  Rf_setAttrib(out, R_RowNamesSymbol, row_names);
  UNPROTECT(1);

  UNPROTECT(2);
  return out;
}

// [[export]]
extern "C" SEXP fs_exists_(SEXP path_sxp, SEXP name_sxp) {

  SEXP out = PROTECT(Rf_allocVector(LGLSXP, Rf_xlength(path_sxp)));
  Rf_setAttrib(out, R_NamesSymbol, Rf_duplicate(name_sxp));

  for (R_xlen_t i = 0; i < Rf_xlength(path_sxp); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path_sxp, i));
    int res = uv_fs_stat(uv_default_loop(), &req, p, NULL);
    LOGICAL(out)[i] = static_cast<int>(res == 0);
    uv_fs_req_cleanup(&req);
  }

  UNPROTECT(1);
  return out;
}

// [[export]]
extern "C" SEXP fs_access_(SEXP path_sxp, SEXP mode_sxp) {

  int mode = INTEGER(mode_sxp)[0];

  SEXP out = PROTECT(Rf_allocVector(LGLSXP, Rf_xlength(path_sxp)));
  Rf_setAttrib(out, R_NamesSymbol, Rf_duplicate(path_sxp));

  for (R_xlen_t i = 0; i < Rf_xlength(path_sxp); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path_sxp, i));
    int res = uv_fs_access(uv_default_loop(), &req, p, mode, NULL);
    LOGICAL(out)[i] = res == 0;
    uv_fs_req_cleanup(&req);
  }

  UNPROTECT(1);
  return out;
}

// [[export]]
extern "C" SEXP fs_chmod_(SEXP path_sxp, SEXP mode_sxp) {
  for (R_xlen_t i = 0; i < Rf_xlength(path_sxp); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path_sxp, i));
    mode_t m = INTEGER(mode_sxp)[i];
    uv_fs_chmod(uv_default_loop(), &req, p, m, NULL);
    stop_for_error(req, "Failed to chmod '%s'", p);
    uv_fs_req_cleanup(&req);
  }

  return R_NilValue;
}

// [[export]]
extern "C" SEXP fs_unlink_(SEXP path) {
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    uv_fs_unlink(uv_default_loop(), &req, p, NULL);
    stop_for_error(req, "Failed to remove '%s'", p);
    uv_fs_req_cleanup(&req);
  }

  return R_NilValue;
}

// [[export]]
extern "C" SEXP
fs_copyfile_(SEXP path_sxp, SEXP new_path_sxp, SEXP overwrite_sxp) {

  bool overwrite = LOGICAL(overwrite_sxp)[0];

  for (R_xlen_t i = 0; i < Rf_xlength(path_sxp); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path_sxp, i));
    const char* n = CHAR(STRING_ELT(new_path_sxp, i));
    uv_fs_copyfile(
        uv_default_loop(),
        &req,
        p,
        n,
        !overwrite ? UV_FS_COPYFILE_EXCL : 0,
        NULL);
    stop_for_error2(req, "Failed to copy '%s' to '%s'", p, n);
    uv_fs_req_cleanup(&req);
  }

  return R_NilValue;
}

// [[export]]
extern "C" SEXP fs_chown_(SEXP path_sxp, SEXP uid_sxp, SEXP gid_sxp) {
  int uid = INTEGER(uid_sxp)[0];
  int gid = INTEGER(gid_sxp)[0];

  for (R_xlen_t i = 0; i < Rf_xlength(path_sxp); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path_sxp, i));
    uv_fs_chown(uv_default_loop(), &req, p, uid, gid, NULL);
    stop_for_error(req, "Failed to chown '%s'", p);
    uv_fs_req_cleanup(&req);
  }

  return R_NilValue;
}

// [[export]]
extern "C" SEXP fs_touch_(SEXP path, SEXP atime_sxp, SEXP mtime_sxp) {

  double atime = REAL(atime_sxp)[0];
  double mtime = REAL(mtime_sxp)[0];

  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    uv_fs_utime(uv_default_loop(), &req, p, atime, mtime, NULL);
    stop_for_error(req, "Failed to touch '%s'", p);
    uv_fs_req_cleanup(&req);
  }

  return R_NilValue;
}
