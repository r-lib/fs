#' Functions to test for file types
#' @return A logical vector
#' @template fs
#' @export
is_file <- function(path) {
  res <- file_info(path)
  setNames(res$type == "file", res$path)
}

#' @rdname is_file
#' @export
is_dir <- function(path) {
  res <- file_info(path)
  setNames(res$type == "directory", res$path)
}

#' @rdname is_file
#' @export
is_link <- function(path) {
  res <- file_info(path)
  setNames(res$type == "symlink", res$path)
}
