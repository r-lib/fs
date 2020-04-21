#include <Rinternals.h>

class CollectorList {
  SEXP data_;
  R_xlen_t n_;

public:
  CollectorList(R_xlen_t size = 1) : n_(0) {
    data_ = Rf_allocVector(VECSXP, size);
    R_PreserveObject(data_);
  }

  void push_back(SEXP x) {
    if (Rf_xlength(data_) == n_) {
      R_ReleaseObject(data_);
      data_ = Rf_lengthgets(data_, n_ * 2);
      R_PreserveObject(data_);
    }
    SET_VECTOR_ELT(data_, n_++, x);
  }

  operator SEXP() {
    if (Rf_xlength(data_) != n_) {
      SETLENGTH(data_, n_);
    }
    return data_;
  }

  ~CollectorList() { R_ReleaseObject(data_); }
};
