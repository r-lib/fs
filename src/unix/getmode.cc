#include "getmode.h"

#if (defined(__APPLE__) && defined(__MACH__)) || defined(__BSD__)
#include <string.h> /* for strmode */
#include <unistd.h> /* for getmode / setmode */
#else
#include <bsd/string.h> /* for strmode */
#include <bsd/unistd.h> /* for getmode / setmode */
#endif

#include <Rcpp.h> /* for Rf_error */

mode_t getmode_(const char* mode_str, mode_t mode) {
  void* out = setmode(mode_str);
  if (out == NULL) {
    // TODO: use stop_for_error here
    Rf_error("Invalid mode '%s'", mode_str);
  }
  mode_t res = getmode(out, mode);
  free(out);
  return res;
}

std::string strmode_(mode_t mode) {
  char out[12];
  strmode(mode, out);

  // The first character is the file type, so we do not return it.
  return out + 1;
}
