#include "getmode.h"
#include "uv.h"

#undef ERROR

#include "CollectorList.h"
#include "Rcpp.h"
#include "error.h"

using namespace Rcpp;

// [[Rcpp::export]]
void mkdir_(CharacterVector path, mode_t mode) {
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    uv_fs_t req;
    const char* p = CHAR(STRING_ELT(path, i));

    // we cannot make the root directory, so just continue;
    if (strcmp(p, "/") == 0 || strcmp(p, "//") == 0 ||
        (strlen(p) == 2 && p[1] == ':' &&
         ((p[0] >= 'a' && p[0] <= 'z') || (p[0] >= 'A' && p[0] <= 'Z')))) {
      continue;
    }

    int fd = uv_fs_mkdir(uv_default_loop(), &req, p, mode, NULL);

    // We want to fail silently if the directory already exists
    if (fd != UV_EEXIST) {
      stop_for_error(req, "Failed to make directory '%s'", p);
    }
    uv_fs_req_cleanup(&req);
  }
}

// If dirent is not unknown, just return it, otherwise stat the file and get
// the filetype from that.
uv_dirent_type_t
get_dirent_type(const char* path, const uv_dirent_type_t& entry_type) {
  if (entry_type == UV_DIRENT_UNKNOWN) {
    uv_fs_t req;
    uv_fs_lstat(uv_default_loop(), &req, path, NULL);
    stop_for_error(req, "Failed to stat '%s'", path);
    uv_dirent_type_t type;
    switch (req.statbuf.st_mode & S_IFMT) {
    case S_IFBLK:
      type = UV_DIRENT_BLOCK;
      break;
    case S_IFCHR:
      type = UV_DIRENT_CHAR;
      break;
    case S_IFDIR:
      type = UV_DIRENT_DIR;
      break;
    case S_IFIFO:
      type = UV_DIRENT_FIFO;
      break;
    case S_IFLNK:
      type = UV_DIRENT_LINK;
      break;
    case S_IFREG:
      type = UV_DIRENT_FILE;
      break;
#ifndef __WIN32
    case S_IFSOCK:
      type = UV_DIRENT_SOCKET;
      break;
#endif
    default:
      type = UV_DIRENT_UNKNOWN;
      break;
    }
    uv_fs_req_cleanup(&req);
    return type;
  }

  return entry_type;
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
    bool recurse,
    CollectorList* value) {
  uv_fs_t req;
  uv_fs_scandir(uv_default_loop(), &req, path, 0, NULL);
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
      value->push_back(fun(name));
    }

    if (recurse && entry_type == UV_DIRENT_DIR) {
      dir_map(fun, name.c_str(), all, file_type, true, value);
    }
    if (next_res != UV_EOF) {
      stop_for_error(req, "Failed to search directory '%s'", path);
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
    bool recurse) {
  int file_type = INTEGER(type)[0];

  CollectorList out;
  for (R_xlen_t i = 0; i < Rf_xlength(path); ++i) {
    const char* p = CHAR(STRING_ELT(path, i));
    dir_map(fun, p, all, file_type, recurse, &out);
  }
  return out.vector();
}
