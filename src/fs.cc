#include "uv.h"

//[[export]]
extern "C" void cleanup_() { uv_loop_close(uv_default_loop()); }
