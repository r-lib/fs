#include "Rinternals.h"
#include "uv.h"

//[[export]]
extern "C" SEXP cleanup_() {
  uv_loop_close(uv_default_loop());
  return R_NilValue;
}
