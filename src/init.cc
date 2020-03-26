#include <R.h>
#include <R_ext/Rdynload.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL

/* FIXME:
   Check these declarations against the C/Fortran source code.
*/

extern "C" {

/* .Call calls */
extern SEXP access_(SEXP, SEXP);
extern SEXP chmod_(SEXP, SEXP);
extern SEXP chown_(SEXP, SEXP, SEXP);
extern SEXP cleanup_();
extern SEXP copyfile_(SEXP, SEXP, SEXP);
extern SEXP create_(SEXP, SEXP);
extern SEXP dir_map_(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP expand_(SEXP, SEXP);
extern SEXP file_code_(SEXP, SEXP);
extern SEXP getgrnam_(SEXP);
extern SEXP getpwnam_(SEXP);
extern SEXP groups_();
extern SEXP link_create_hard_(SEXP, SEXP);
extern SEXP link_create_symbolic_(SEXP, SEXP);
extern SEXP mkdir_(SEXP, SEXP);
extern SEXP move_(SEXP, SEXP);
extern SEXP path_(SEXP, SEXP);
extern SEXP readlink_(SEXP);
extern SEXP realize_(SEXP);
extern SEXP rmdir_(SEXP);
extern SEXP stat_(SEXP, SEXP);
extern SEXP strmode_(SEXP);
extern SEXP tidy_(SEXP);
extern SEXP touch_(SEXP, SEXP, SEXP);
extern SEXP _fs_unlink_(SEXP);
extern SEXP _fs_users_();
extern SEXP getmode_(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"access_", (DL_FUNC)&access_, 2},
    {"chmod_", (DL_FUNC)&chmod_, 2},
    {"chown_", (DL_FUNC)&chown_, 3},
    {"cleanup_", (DL_FUNC)&cleanup_, 0},
    {"copyfile_", (DL_FUNC)&copyfile_, 3},
    {"create_", (DL_FUNC)&create_, 2},
    {"dir_map_", (DL_FUNC)&dir_map_, 6},
    {"expand_", (DL_FUNC)&expand_, 2},
    {"file_code_", (DL_FUNC)&file_code_, 2},
    {"getgrnam_", (DL_FUNC)&getgrnam_, 1},
    {"getpwnam_", (DL_FUNC)&getpwnam_, 1},
    {"groups_", (DL_FUNC)&groups_, 0},
    {"link_create_hard_", (DL_FUNC)&link_create_hard_, 2},
    {"link_create_symbolic_", (DL_FUNC)&link_create_symbolic_, 2},
    {"mkdir_", (DL_FUNC)&mkdir_, 2},
    {"move_", (DL_FUNC)&move_, 2},
    {"path_", (DL_FUNC)&path_, 2},
    {"readlink_", (DL_FUNC)&readlink_, 1},
    {"realize_", (DL_FUNC)&realize_, 1},
    {"rmdir_", (DL_FUNC)&rmdir_, 1},
    {"stat_", (DL_FUNC)&stat_, 2},
    {"tidy_", (DL_FUNC)&tidy_, 1},
    {"touch_", (DL_FUNC)&touch_, 3},
    {"_fs_unlink_", (DL_FUNC)&_fs_unlink_, 1},
    {"_fs_users_", (DL_FUNC)&_fs_users_, 0},
    {"getmode_", (DL_FUNC)&getmode_, 2},
    {"strmode_", (DL_FUNC)&strmode_, 1},
    {NULL, NULL, 0}};

void R_init_fs(DllInfo* dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
}
