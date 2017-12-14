#pragma once

#include "Rcpp.h"
#include "uv.h"

using namespace Rcpp;

#define stop_for_error(file, err)                   \
  if (err < 0) {                                    \
    Rcpp::stop("'%s': %s", file, uv_strerror(err)); \
  }
