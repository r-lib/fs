#pragma once

#include "Rcpp.h"
#include "uv.h"

using namespace Rcpp;

#define check_for_error(X)        \
  int err = (X);                  \
  if (err < 0) {                  \
    Rcpp::stop(uv_strerror(err)); \
  }
