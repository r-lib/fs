# nocov start
.onLoad <- function(...) {
  register_s3_method("pillar", "pillar_shaft", "fs_path")
  register_s3_method("pillar", "type_sum", "fs_path")
  register_s3_method("testthat", "compare", "fs_path")
  register_s3_method("vctrs", "vec_ptype2", "fs_path.fs_path")
  register_s3_method("vctrs", "vec_ptype2", "character.fs_path")
  register_s3_method("vctrs", "vec_ptype2", "fs_path.character")
  register_s3_method("vctrs", "vec_cast", "fs_path.fs_path")
  register_s3_method("vctrs", "vec_cast", "character.fs_path")
  register_s3_method("vctrs", "vec_cast", "fs_path.character")

  register_s3_method("pillar", "pillar_shaft", "fs_bytes")
  register_s3_method("pillar", "type_sum", "fs_bytes")
  register_s3_method("vctrs", "vec_ptype2", "fs_bytes.fs_bytes")
  register_s3_method("vctrs", "vec_ptype2", "double.fs_bytes")
  register_s3_method("vctrs", "vec_ptype2", "fs_bytes.double")
  register_s3_method("vctrs", "vec_cast", "fs_bytes.fs_bytes")
  register_s3_method("vctrs", "vec_cast", "double.fs_bytes")
  register_s3_method("vctrs", "vec_cast", "fs_bytes.double")
  register_s3_method("vctrs", "vec_ptype2", "integer.fs_bytes")
  register_s3_method("vctrs", "vec_ptype2", "fs_bytes.integer")
  register_s3_method("vctrs", "vec_cast", "integer.fs_bytes")
  register_s3_method("vctrs", "vec_cast", "fs_bytes.integer")

  register_s3_method("pillar", "pillar_shaft", "fs_perms")
  register_s3_method("pillar", "type_sum", "fs_perms")
  register_s3_method("testthat", "compare", "fs_perms")
  register_s3_method("vctrs", "vec_ptype2", "fs_perms.fs_perms")
  register_s3_method("vctrs", "vec_ptype2", "double.fs_perms")
  register_s3_method("vctrs", "vec_ptype2", "fs_perms.double")
  register_s3_method("vctrs", "vec_cast", "fs_perms.fs_perms")
  register_s3_method("vctrs", "vec_cast", "double.fs_perms")
  register_s3_method("vctrs", "vec_cast", "fs_perms.double")
  register_s3_method("vctrs", "vec_ptype2", "integer.fs_perms")
  register_s3_method("vctrs", "vec_ptype2", "fs_perms.integer")
  register_s3_method("vctrs", "vec_cast", "integer.fs_perms")
  register_s3_method("vctrs", "vec_cast", "fs_perms.integer")
  register_s3_method("vctrs", "vec_ptype2", "character.fs_perms")
  register_s3_method("vctrs", "vec_ptype2", "fs_perms.character")
  register_s3_method("vctrs", "vec_cast", "character.fs_perms")
  register_s3_method("vctrs", "vec_cast", "fs_perms.character")

  invisible()
}

register_s3_method <- function(pkg, generic, class, fun = NULL) {
  stopifnot(is.character(pkg), length(pkg) == 1)
  stopifnot(is.character(generic), length(generic) == 1)
  stopifnot(is.character(class), length(class) == 1)

  if (is.null(fun)) {
    fun <- get(paste0(generic, ".", class), envir = parent.frame())
  } else {
    stopifnot(is.function(fun))
  }

  if (pkg %in% loadedNamespaces()) {
    registerS3method(generic, class, fun, envir = asNamespace(pkg))
  }

  # Always register hook in case package is later unloaded & reloaded
  setHook(
    packageEvent(pkg, "onLoad"),
    function(...) {
      registerS3method(generic, class, fun, envir = asNamespace(pkg))
    }
  )
}
# nocov end
