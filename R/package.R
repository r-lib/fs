#' @useDynLib fs, .registration = TRUE
#' @importFrom Rcpp sourceCpp
#' @importFrom methods setOldClass
NULL

# nocov start
.onUnload <- function(libpath) {
  cleanup_()
  library.dynam.unload("fs", libpath)
}
# nocov end
