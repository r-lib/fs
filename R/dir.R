#' Move a directory
#'
#' @inherit file_move
#' @include file.R
#' @export
dir_move <- file_move

#' Directory information
#' @inherit file_info
#' @export
dir_info <- file_info

#' Create a directory
#' @template fs
#' @inheritParams file_create
#' @examples
#' x <- tempfile()
#' try(is_dir(x))
#' dir_create(x)
#' is_dir(x)
#' @export
dir_create <- function(path, mode = "u+rwx,go+rx") {
  path <- path_expand(path)

  mkdir_(path, mode)

  invisible(path)
}
