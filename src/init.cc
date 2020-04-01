#include <R.h>
#include <R_ext/Rdynload.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL

/* FIXME:
   Check these declarations against the C/Fortran source code.
*/

extern "C" {

/* .Call calls */
extern SEXP fs_access_(SEXP, SEXP);
extern SEXP fs_chmod_(SEXP, SEXP);
extern SEXP fs_chown_(SEXP, SEXP, SEXP);
extern SEXP fs_cleanup_();
extern SEXP fs_copyfile_(SEXP, SEXP, SEXP);
extern SEXP fs_create_(SEXP, SEXP);
extern SEXP fs_dir_map_(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP fs_expand_(SEXP, SEXP);
extern SEXP fs_file_code_(SEXP, SEXP);
extern SEXP fs_getgrnam_(SEXP);
extern SEXP fs_getpwnam_(SEXP);
extern SEXP fs_groups_();
extern SEXP fs_link_create_hard_(SEXP, SEXP);
extern SEXP fs_link_create_symbolic_(SEXP, SEXP);
extern SEXP fs_mkdir_(SEXP, SEXP);
extern SEXP fs_move_(SEXP, SEXP);
extern SEXP fs_path_(SEXP, SEXP);
extern SEXP fs_readlink_(SEXP);
extern SEXP fs_realize_(SEXP);
extern SEXP fs_rmdir_(SEXP);
extern SEXP fs_stat_(SEXP, SEXP);
extern SEXP fs_strmode_(SEXP);
extern SEXP fs_tidy_(SEXP);
extern SEXP fs_touch_(SEXP, SEXP, SEXP);
extern SEXP fs_unlink_(SEXP);
extern SEXP fs_users_();
extern SEXP fs_getmode_(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"fs_access_", (DL_FUNC)&fs_access_, 2},
    {"fs_chmod_", (DL_FUNC)&fs_chmod_, 2},
    {"fs_chown_", (DL_FUNC)&fs_chown_, 3},
    {"fs_cleanup_", (DL_FUNC)&fs_cleanup_, 0},
    {"fs_copyfile_", (DL_FUNC)&fs_copyfile_, 3},
    {"fs_create_", (DL_FUNC)&fs_create_, 2},
    {"fs_dir_map_", (DL_FUNC)&fs_dir_map_, 6},
    {"fs_expand_", (DL_FUNC)&fs_expand_, 2},
    {"fs_file_code_", (DL_FUNC)&fs_file_code_, 2},
    {"fs_getgrnam_", (DL_FUNC)&fs_getgrnam_, 1},
    {"fs_getpwnam_", (DL_FUNC)&fs_getpwnam_, 1},
    {"fs_groups_", (DL_FUNC)&fs_groups_, 0},
    {"fs_link_create_hard_", (DL_FUNC)&fs_link_create_hard_, 2},
    {"fs_link_create_symbolic_", (DL_FUNC)&fs_link_create_symbolic_, 2},
    {"fs_mkdir_", (DL_FUNC)&fs_mkdir_, 2},
    {"fs_move_", (DL_FUNC)&fs_move_, 2},
    {"fs_path_", (DL_FUNC)&fs_path_, 2},
    {"fs_readlink_", (DL_FUNC)&fs_readlink_, 1},
    {"fs_realize_", (DL_FUNC)&fs_realize_, 1},
    {"fs_rmdir_", (DL_FUNC)&fs_rmdir_, 1},
    {"fs_stat_", (DL_FUNC)&fs_stat_, 2},
    {"fs_tidy_", (DL_FUNC)&fs_tidy_, 1},
    {"fs_touch_", (DL_FUNC)&fs_touch_, 3},
    {"fs_unlink_", (DL_FUNC)&fs_unlink_, 1},
    {"fs_users_", (DL_FUNC)&fs_users_, 0},
    {"fs_getmode_", (DL_FUNC)&fs_getmode_, 2},
    {"fs_strmode_", (DL_FUNC)&fs_strmode_, 1},
    {NULL, NULL, 0}};

void R_init_fs(DllInfo* dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
}
