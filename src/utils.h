#include "Rcpp.h"

inline Rcpp::CharacterVector asCharacterVector(std::string x) {
  return Rcpp::CharacterVector(Rf_mkCharCE(x.c_str(), CE_UTF8));
}
