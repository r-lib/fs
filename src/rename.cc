#include "Rcpp.h"
#include "utils.h"
#include "uv.h"

using namespace Rcpp;

// [[Rcpp::export]]
void rename_(std::string path, std::string new_path) {
  uv_fs_t file_req;
  check_for_error(uv_fs_rename(uv_default_loop(), &file_req, path.c_str(),
                               new_path.c_str(), NULL));
  uv_fs_req_cleanup(&file_req);
}
