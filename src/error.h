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
  signal_condition(req, __FILE__ ":" STRING(__LINE__), true, format, one)

#define stop_for_error2(req, format, one, two)                                 \
  signal_condition(req, __FILE__ ":" STRING(__LINE__), true, format, one, two)

#define warn_for_error(req, format, one)                                       \
  signal_condition(req, __FILE__ ":" STRING(__LINE__), false, format, one)

bool signal_condition(
    uv_fs_t req, const char* loc, bool error, const char* format, ...);

#ifdef __cplusplus
}
#endif

#endif /* ERROR_H_ */
