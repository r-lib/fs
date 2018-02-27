#include "utils.h"
#include "error.h"

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
