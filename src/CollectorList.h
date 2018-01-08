#include <Rcpp.h>

using Rcpp::List;

class CollectorList {
  List data_;
  R_xlen_t n_;

public:
  CollectorList(R_xlen_t size = 1) : data_(size), n_(0) {}

  void push_back(SEXP x) {
    if (Rf_xlength(data_) == n_) {
      data_ = Rf_lengthgets(data_, n_ * 2);
    }
    SET_VECTOR_ELT(data_, n_++, x);
  }

  List vector() {
    if (Rf_xlength(data_) != n_) {
      data_ = Rf_xlengthgets(data_, n_);
    }
    return data_;
  }
};
