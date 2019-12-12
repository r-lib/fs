#include "utils.h"
#include "error.h"

// If dirent is not unknown, just return it, otherwise stat the file and get
// the filetype from that.
uv_dirent_type_t
get_dirent_type(const char* path, const uv_dirent_type_t& entry_type,bool fail) {
  if (entry_type == UV_DIRENT_UNKNOWN) {
    uv_fs_t req;
    uv_fs_lstat(uv_default_loop(), &req, path, NULL);
    if (!fail && warn_for_error(req, "Failed to stat '%s'", path)) {
      return UV_DIRENT_UNKNOWN;
    }
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

bool is_windows_path(const std::string& x) {
  if (x.length() < 2) {
    return false;
  }
  char first = x.at(0);

  return ((first >= 'A' && first <= 'Z') || (first >= 'a' && first <= 'z')) &&
         x.at(1) == ':';
}

std::string path_tidy_(const std::string& in) {
  std::string out;
  out.reserve(in.size());
  char prev = '\0';
  size_t i = 0;
  size_t n = in.length();
  while (i < n) {
    char curr = in.at(i++);

    // convert `\\` to `/`
    if (curr == '\\') {
      curr = '/';
    }

    // convert multiple // to single /, as long as they are not at the start
    // (when they could be UNC paths).
    if (i > 2 && prev == '/' && curr == '/') {
      while (i < n && prev == '/' && curr == '/') {
        prev = curr;
        curr = in.at(i++);
      }
      if (i == n && curr == '/') {
        break;
      }
    }

    prev = curr;
    out.push_back(prev);
  }

  if (is_windows_path(out)) {
    // Ensure the first letter is capitalized
    out[0] = toupper(out[0]);

    // Append a / if this is a root path
    if (out.length() == 2) {
      out.push_back('/');
    } else if (out.length() > 3 && *out.rbegin() == '/') {
      out.erase(out.end() - 1);
    }
    return out;
  }

  // Remove trailing / from paths (that aren't also the beginning)
  if (out.length() > 1 && *out.rbegin() == '/') {
    out.erase(out.end() - 1);
  }

  return out;
}
