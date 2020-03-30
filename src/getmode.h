#pragma once

#define R_NO_REMAP
#include <Rinternals.h>
#undef R_NO_REMAP

#include "utils.h"

// [[export]]
extern "C" SEXP getmode_(SEXP mode_str_sxp, SEXP mode_sxp);

// [[export]]
extern "C" SEXP strmode_(SEXP mode_sxp);

// [[export]]
extern "C" SEXP file_code_(SEXP path_sxp, SEXP mode_sxp);
