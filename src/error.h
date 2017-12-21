#ifndef CONDITION_H_
#define CONDITION_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <Rinternals.h>
#include <stdarg.h>
#include "uv.h"

#define STRING_I(x) #x
#define STRING(x) STRING_I(x)

#define stop_for_error(req, format, ...) \
  error_condition(req, __FILE__ ":" STRING(__LINE__), format, __VA_ARGS__)

#ifdef __cplusplus
SEXP error_condition(uv_fs_t req, const char* loc, const char* format, ...);
}
#endif

#endif /* CONDITION_H_ */
