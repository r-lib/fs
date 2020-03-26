#' @useDynLib fs, .registration = TRUE
#' @importFrom methods setOldClass
NULL

# nocov start
.onUnload <- function(libpath) {
  .Call(cleanup_)
  library.dynam.unload("fs", libpath)
}
# nocov end
