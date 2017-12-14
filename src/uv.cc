#include "uv.h"
#include "utils.h"

// [[Rcpp::export]]
void close_uv_() {
  int res = uv_loop_close(uv_default_loop());
  stop_for_error("", res);
}
