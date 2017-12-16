#' Create a file
#'
#' Unlike [file.create()], will not truncate an existing file.
#'
#' @template fs
#' @param mode If file is created, what mode should it have?
#' @export
#' @examples
#' x <- file_create(tempfile())
#' x
file_create <- function(path, mode = "u+rw,go+r") {
  stopifnot(length(mode) == 1)

  path <- enc2utf8(path)
  create_(path_expand(path), mode)

  invisible(path)
}
