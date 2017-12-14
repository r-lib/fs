#' @useDynLib fs, .registration = TRUE
#' @importFrom Rcpp sourceCpp
NULL

.onUnload <- function(libpath) {
  close_uv_()
  library.dynam.unload("fs", libpath)
}
