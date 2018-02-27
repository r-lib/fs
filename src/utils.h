#include "Rcpp.h"
#include "uv.h"

inline Rcpp::CharacterVector asCharacterVector(std::string x) {
  return Rcpp::CharacterVector(Rf_mkCharCE(x.c_str(), CE_UTF8));
}

// If dirent is not unknown, just return it, otherwise stat the file and get
// the filetype from that.
uv_dirent_type_t get_dirent_type(
    const char* path, const uv_dirent_type_t& entry_type = UV_DIRENT_UNKNOWN);
