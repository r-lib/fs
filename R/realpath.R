#' Return the canonicalized absolute pathname
#'
#' This is functionally equivalent to [base::normalizePath()].
#'
#' @template fileuv
#' @return `[character(1)]` the fully resolved path.
#' @aliases dir_realpath
#' @export
fs_realpath <- function(path) {
  realpath_(fs_expand(path))
}
