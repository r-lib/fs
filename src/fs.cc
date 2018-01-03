#include "uv.h"

//[[Rcpp::export]]
void cleanup_() { uv_loop_close(uv_default_loop()); }
