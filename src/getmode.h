#pragma once

#include <sys/types.h>
#include <string>

// [[Rcpp::export]]
mode_t getmode_(const char* mode_str, mode_t mode);

// [[Rcpp::export]]
std::string strmode_(mode_t mode);

// [[Rcpp::export]]
std::string file_code_(std::string path, mode_t mode);
