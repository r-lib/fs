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
extern SEXP _fs_getpwnam_(SEXP);
extern SEXP _fs_groups_();
extern SEXP _fs_link_create_hard_(SEXP, SEXP);
extern SEXP _fs_link_create_symbolic_(SEXP, SEXP);
extern SEXP _fs_mkdir_(SEXP, SEXP);
extern SEXP _fs_move_(SEXP, SEXP);
extern SEXP _fs_path_(SEXP, SEXP);
extern SEXP _fs_readlink_(SEXP);
extern SEXP _fs_realize_(SEXP);
extern SEXP _fs_rmdir_(SEXP);
extern SEXP _fs_stat_(SEXP, SEXP);
extern SEXP strmode_(SEXP);
extern SEXP _fs_tidy_(SEXP);
extern SEXP _fs_touch_(SEXP, SEXP, SEXP);
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
    {"_fs_getpwnam_", (DL_FUNC)&_fs_getpwnam_, 1},
    {"_fs_groups_", (DL_FUNC)&_fs_groups_, 0},
    {"_fs_link_create_hard_", (DL_FUNC)&_fs_link_create_hard_, 2},
    {"_fs_link_create_symbolic_", (DL_FUNC)&_fs_link_create_symbolic_, 2},
    {"_fs_mkdir_", (DL_FUNC)&_fs_mkdir_, 2},
    {"_fs_move_", (DL_FUNC)&_fs_move_, 2},
    {"_fs_path_", (DL_FUNC)&_fs_path_, 2},
    {"_fs_readlink_", (DL_FUNC)&_fs_readlink_, 1},
    {"_fs_realize_", (DL_FUNC)&_fs_realize_, 1},
    {"_fs_rmdir_", (DL_FUNC)&_fs_rmdir_, 1},
    {"_fs_stat_", (DL_FUNC)&_fs_stat_, 2},
    {"_fs_tidy_", (DL_FUNC)&_fs_tidy_, 1},
    {"_fs_touch_", (DL_FUNC)&_fs_touch_, 3},
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
