#' Functions to test for file types
#' @return A logical vector
#' @template fs
#' @export
is_file <- function(path) {
  file_info(path)$type == "file"
}

#' @rdname is_file
#' @export
is_directory <- function(path) {
  file_info(path)$type == "directory"
}

#' @rdname is_file
#' @export
is_link <- function(path) {
  file_info(path)$type == "symlink"
}
