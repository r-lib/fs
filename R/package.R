#' @useDynLib fs, .registration = TRUE
#' @importFrom Rcpp sourceCpp
NULL

.onUnload <- function(libpath) {
  library.dynam.unload("fs", libpath)
}
