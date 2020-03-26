#include <Rcpp.h>

#ifndef __WIN32
#include <grp.h>
#include <pwd.h>
#include <sys/types.h>
#include <unistd.h>
#endif

// [[export]]
extern "C" SEXP getpwnam_(SEXP name_sxp) {
  SEXP out = PROTECT(Rf_allocVector(INTSXP, Rf_xlength(name_sxp)));
  int* out_p = INTEGER(out);

#ifndef __WIN32
  for (R_xlen_t i = 0; i < Rf_xlength(name_sxp); ++i) {
    passwd* pwd;
    pwd = getpwnam(CHAR(STRING_ELT(name_sxp, i)));
    if (pwd != NULL) {
      out_p[i] = pwd->pw_uid;
    } else {
      out_p[i] = NA_INTEGER;
    }
  }
#endif

  UNPROTECT(1);
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

// [[export]]
extern "C" SEXP groups_() {
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

  SEXP out = PROTECT(Rf_allocVector(VECSXP, 2));
  SEXP ids_sxp = PROTECT(Rf_allocVector(INTSXP, ids.size()));
  SEXP group_names_sxp = PROTECT(Rf_allocVector(STRSXP, names.size()));

  for (R_xlen_t i = 0; i < ids.size(); ++i) {
    INTEGER(ids_sxp)[i] = ids[i];
    SET_STRING_ELT(group_names_sxp, i, Rf_mkChar(names[i].c_str()));
  }
  SET_VECTOR_ELT(out, 0, ids_sxp);
  SET_VECTOR_ELT(out, 1, group_names_sxp);

  SEXP col_names_sxp = PROTECT(Rf_allocVector(STRSXP, 2));
  SET_STRING_ELT(col_names_sxp, 0, Rf_mkChar("group_id"));
  SET_STRING_ELT(col_names_sxp, 1, Rf_mkChar("group_name"));
  Rf_setAttrib(out, R_NamesSymbol, col_names_sxp);
  UNPROTECT(1);

  Rf_setAttrib(out, R_ClassSymbol, Rf_mkString("data.frame"));

  SEXP row_names = PROTECT(Rf_allocVector(INTSXP, 2));
  INTEGER(row_names)[0] = NA_INTEGER;
  INTEGER(row_names)[1] = -names.size();
  Rf_setAttrib(out, R_RowNamesSymbol, row_names);
  UNPROTECT(1);

  UNPROTECT(3);

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
