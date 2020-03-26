#pragma once

//#define R_NO_REMAP
//#include <Rinternals.h>
//#undef R_NO_REMAP
#include <Rcpp.h>

#include <string>

unsigned short getmode__(const char* mode_str, unsigned short mode);

// [[export]]
extern "C" SEXP getmode_(SEXP mode_str_sxp, SEXP mode_sxp);

// [[Rcpp::export]]
std::string strmode_(unsigned short mode);

// [[Rcpp::export]]
std::string file_code_(std::string path, unsigned short mode);
