#include <Rcpp.h>

#ifndef __WIN32
#include <grp.h>
#include <pwd.h>
#include <sys/types.h>
#include <unistd.h>
#endif

// [[Rcpp::export]]
Rcpp::IntegerVector getpwnam_(Rcpp::CharacterVector name) {
  Rcpp::IntegerVector out(Rf_xlength(name));

#ifndef __WIN32
  for (R_xlen_t i = 0; i < Rf_xlength(name); ++i) {
    passwd* pwd;
    pwd = getpwnam(CHAR(STRING_ELT(name, i)));
    if (pwd != NULL) {
      out[i] = pwd->pw_uid;
    } else {
      out[i] = NA_INTEGER;
    }
  }
#endif
  return out;
}

// [[export]]
extern "C" SEXP getgrnam_(SEXP name_sxp) {
  SEXP out = PROTECT(Rf_allocVector(INTSXP, Rf_xlength(name_sxp)));
  int* out_p = INTEGER(out);

#ifndef __WIN32
  for (R_xlen_t i = 0; i < Rf_xlength(name_sxp); ++i) {
    group* grp;
    grp = getgrnam(CHAR(STRING_ELT(name_sxp, i)));
    if (grp != NULL) {
      out_p[i] = grp->gr_gid;
    } else {
      out_p[i] = NA_INTEGER;
    }
  }
#endif

  UNPROTECT(1);
  return out;
}

// [[Rcpp::export]]
Rcpp::List groups_() {
  std::vector<std::string> names;
  std::vector<int> ids;
#ifndef __WIN32
  group* grp = getgrent();
  while (grp != NULL) {
    names.push_back(grp->gr_name);
    ids.push_back(grp->gr_gid);
    grp = getgrent();
  }
  endgrent();
#endif
  Rcpp::List out = Rcpp::List::create(
      Rcpp::_["group_id"] = Rcpp::wrap(ids),
      Rcpp::_["group_name"] = Rcpp::wrap(names));
  out.attr("class") = "data.frame";
  out.attr("row.names") =
      Rcpp::IntegerVector::create(NA_INTEGER, -names.size());
  return out;
}

// [[Rcpp::export]]
Rcpp::List users_() {
  std::vector<std::string> names;
  std::vector<int> ids;
#ifndef __WIN32
  passwd* pwd = getpwent();
  while (pwd != NULL) {
    names.push_back(pwd->pw_name);
    ids.push_back(pwd->pw_uid);
    pwd = getpwent();
  }
  endpwent();
#endif
  Rcpp::List out = Rcpp::List::create(
      Rcpp::_["user_id"] = Rcpp::wrap(ids),
      Rcpp::_["user_name"] = Rcpp::wrap(names));
  out.attr("class") = "data.frame";
  out.attr("row.names") =
      Rcpp::IntegerVector::create(NA_INTEGER, -names.size());
  return out;
}
