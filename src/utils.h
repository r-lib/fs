#pragma once

#include "uv.h"

#include <string>

// If dirent is not unknown, just return it, otherwise stat the file and get
// the filetype from that.
uv_dirent_type_t get_dirent_type(
    const char* path,
    const uv_dirent_type_t& entry_type = UV_DIRENT_UNKNOWN,
    bool fail = true);

std::string path_tidy_(const std::string& in);
