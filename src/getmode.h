#pragma once

#define R_NO_REMAP
#include <Rinternals.h>
#undef R_NO_REMAP

#include <string>

unsigned short getmode__(const char* mode_str, unsigned short mode);

std::string strmode__(unsigned short mode);

std::string file_code__(const std::string& path, unsigned short mode);

extern "C" {

// [[export]]
SEXP getmode_(SEXP mode_str_sxp, SEXP mode_sxp);

// [[export]]
SEXP strmode_(SEXP mode);

// [[export]]
SEXP file_code_(SEXP path, SEXP mode);
}
