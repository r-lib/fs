#include <Rcpp.h>

#ifndef __WIN32
#include <grp.h>
#include <pwd.h>
#include <sys/types.h>
#include <unistd.h>
#endif

using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector getpwnam_(CharacterVector name) {
  IntegerVector out(Rf_xlength(name));

#ifndef __WIN32
  for (R_xlen_t i = 0; i < Rf_xlength(name); ++i) {
    passwd *pwd;
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

// [[Rcpp::export]]
IntegerVector getgrnam_(CharacterVector name) {
  IntegerVector out(Rf_xlength(name));

#ifndef __WIN32
  for (R_xlen_t i = 0; i < Rf_xlength(name); ++i) {
    group *grp;
    grp = getgrnam(CHAR(STRING_ELT(name, i)));
    if (grp != NULL) {
      out[i] = grp->gr_gid;
    } else {
      out[i] = NA_INTEGER;
    }
  }
#endif
  return out;
}

// [[Rcpp::export]]
List groups_() {
  std::vector<std::string> names;
  std::vector<int> ids;
#ifndef __WIN32
  group *grp = getgrent();
  while (grp != NULL) {
    names.push_back(grp->gr_name);
    ids.push_back(grp->gr_gid);
    grp = getgrent();
  }
  endgrent();
#endif
  List out =
      List::create(_["group_id"] = wrap(ids), _["group_name"] = wrap(names));
  out.attr("class") = "data.frame";
  out.attr("row.names") = IntegerVector::create(NA_INTEGER, -names.size());
  return out;
}

// [[Rcpp::export]]
List users_() {
  std::vector<std::string> names;
  std::vector<int> ids;
#ifndef __WIN32
  passwd *pwd = getpwent();
  while (pwd != NULL) {
    names.push_back(pwd->pw_name);
    ids.push_back(pwd->pw_uid);
    pwd = getpwent();
  }
  endpwent();
#endif
  List out =
      List::create(_["user_id"] = wrap(ids), _["user_name"] = wrap(names));
  out.attr("class") = "data.frame";
  out.attr("row.names") = IntegerVector::create(NA_INTEGER, -names.size());
  return out;
}
