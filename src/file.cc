#include "Rcpp.h"
#include "utils.h"
#include "uv.h"

using namespace Rcpp;

// [[Rcpp::export]]
void move_(std::string path, std::string new_path) {
  uv_fs_t file_req;
  int res = uv_fs_rename(uv_default_loop(), &file_req, path.c_str(),
                         new_path.c_str(), NULL);
  stop_for_error(path, res);
  uv_fs_req_cleanup(&file_req);
}
