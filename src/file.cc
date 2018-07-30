#ifndef __STDC_FORMAT_MACROS
#define __STDC_FORMAT_MACROS 1
#endif

#include "getmode.h"
#include "uv.h"

#undef ERROR

#include "Rcpp.h"
#include "error.h"

#ifndef __WIN32
#include <grp.h>
#include <pwd.h>
#endif

#include <inttypes.h>

using namespace Rcpp;

// [[Rcpp::export]]
void move_(CharacterVector path, CharacterVector new_path) {
  for (R_xlen_t i = 0; i < Rf_xlength(new_path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    const char* n = CHAR(STRING_ELT(new_path, i));
    uv_fs_rename(uv_default_loop(), &req, p, n, NULL);
    stop_for_error2(req, "Failed to move '%s'to '%s'", p, n);
    uv_fs_req_cleanup(&req);
  }
}

// [[Rcpp::export]]
void create_(CharacterVector path, mode_t mode) {
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    int fd = uv_fs_open(
        uv_default_loop(), &req, p, UV_FS_O_CREAT | UV_FS_O_WRONLY, mode, NULL);
    stop_for_error(req, "Failed to open '%s'", p);

    uv_fs_close(uv_default_loop(), &req, fd, NULL);
    stop_for_error(req, "Failed to close '%s'", p);

    uv_fs_req_cleanup(&req);
  }
}

// [[Rcpp::export]]
List stat_(CharacterVector path, bool fail) {
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

  List out = List(18);
  CharacterVector names = CharacterVector(18);

  SET_STRING_ELT(names, 0, Rf_mkChar("path"));
  SET_VECTOR_ELT(out, 0, Rf_duplicate(path));

  SET_STRING_ELT(names, 1, Rf_mkChar("device_id"));
  SET_VECTOR_ELT(out, 1, Rf_allocVector(REALSXP, n));

  SET_STRING_ELT(names, 2, Rf_mkChar("type"));
  SET_VECTOR_ELT(out, 2, Rf_allocVector(INTSXP, n));

  SET_STRING_ELT(names, 3, Rf_mkChar("permissions"));
  SET_VECTOR_ELT(out, 3, Rf_allocVector(INTSXP, n));
  Rf_classgets(VECTOR_ELT(out, 3), Rf_mkString("fs_perms"));

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
  Rf_classgets(VECTOR_ELT(out, 9), Rf_mkString("fs_bytes"));

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
      sprintf(buf, "%" PRIu64, st.st_uid);
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
      sprintf(buf, "%" PRIu64, st.st_gid);
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
  out.attr("names") = names;
  out.attr("class") = CharacterVector::create("tbl", "tbl_df", "data.frame");
  out.attr("row.names") = IntegerVector::create(NA_INTEGER, -i);

  return out;
}

// [[Rcpp::export]]
LogicalVector access_(CharacterVector path, int mode) {
  LogicalVector out = LogicalVector(Rf_xlength(path));
  Rf_setAttrib(out, R_NamesSymbol, Rf_duplicate(path));

  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    int res = uv_fs_access(uv_default_loop(), &req, p, mode, NULL);
    LOGICAL(out)[i] = res == 0;
    uv_fs_req_cleanup(&req);
  }
  return out;
}

// [[Rcpp::export]]
void chmod_(CharacterVector path, IntegerVector mode) {
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    mode_t m = INTEGER(mode)[i];
    uv_fs_chmod(uv_default_loop(), &req, p, m, NULL);
    stop_for_error(req, "Failed to chmod '%s'", p);
    uv_fs_req_cleanup(&req);
  }
}

// [[Rcpp::export]]
void unlink_(CharacterVector path) {
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    uv_fs_unlink(uv_default_loop(), &req, p, NULL);
    stop_for_error(req, "Failed to remove '%s'", p);
    uv_fs_req_cleanup(&req);
  }
}

// [[Rcpp::export]]
void copyfile_(CharacterVector path, CharacterVector new_path, bool overwrite) {
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    const char* n = CHAR(STRING_ELT(new_path, i));
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
}

// [[Rcpp::export]]
void chown_(CharacterVector path, int uid, int gid) {
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    uv_fs_chown(uv_default_loop(), &req, p, uid, gid, NULL);
    stop_for_error(req, "Failed to chown '%s'", p);
    uv_fs_req_cleanup(&req);
  }
}

// [[Rcpp::export]]
void touch_(CharacterVector path, double atime, double mtime) {
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));
    uv_fs_utime(uv_default_loop(), &req, p, atime, mtime, NULL);
    stop_for_error(req, "Failed to touch '%s'", p);
    uv_fs_req_cleanup(&req);
  }
}
