#include <Rinternals.h>

class CollectorList {
  SEXP data_;
  R_xlen_t n_;
  bool free_;

public:
  CollectorList(R_xlen_t size = 1) : n_(0) {
    data_ = Rf_allocVector(VECSXP, size);
    R_PreserveObject(data_);
    free_ = true;
  }

  void push_back(SEXP x) {
    if (Rf_xlength(data_) == n_) {
      R_ReleaseObject(data_);
      free_ = false;
      data_ = Rf_lengthgets(data_, n_ * 2);
      R_PreserveObject(data_);
      free_ = true;
    }
    SET_VECTOR_ELT(data_, n_++, x);
  }

  operator SEXP() {
    if (Rf_xlength(data_) != n_) {
      R_ReleaseObject(data_);
      free_ = false;
      data_ = Rf_lengthgets(data_, n_);
      R_PreserveObject(data_);
      free_ = true;
    }
    return data_;
  }

  ~CollectorList() { if (free_) R_ReleaseObject(data_); }
};
