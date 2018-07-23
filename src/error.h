#ifndef ERROR_H_
#define ERROR_H_

#include <Rinternals.h>
#include <stdarg.h>

#undef ERROR
#include "uv.h"

#ifdef __cplusplus
extern "C" {
#endif

#define STRING_I(x) #x
#define STRING(x) STRING_I(x)

#define stop_for_error(req, format, one)                                       \
  error_condition(req, __FILE__ ":" STRING(__LINE__), format, one)

#define stop_for_error2(req, format, one, two)                                 \
  error_condition(req, __FILE__ ":" STRING(__LINE__), format, one, two)

bool error_condition(uv_fs_t req, const char* loc, const char* format, ...);

#ifdef __cplusplus
}
#endif

#endif /* ERROR_H_ */
