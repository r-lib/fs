#pragma once

#include <string>

// [[Rcpp::export]]
unsigned short getmode_(const char* mode_str, unsigned short mode);

// [[Rcpp::export]]
std::string strmode_(unsigned short mode);

// [[Rcpp::export]]
std::string file_code_(std::string path, unsigned short mode);
