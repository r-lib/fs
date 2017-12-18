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

#' List files in a directory
#'
#' @param relative Should filenames be returned relative to the input path?
#' @template path
#' @export
#' @examples
#' dir_list(system.file())
#' dir_list(system.file(), relative = TRUE)
dir_list <- function(path, relative = FALSE) {
  path <- path_expand(path)

  files <- scandir_(path)
  if (!isTRUE(relative)) {
    full_path <- path_norm(path)
    files <- lapply(files, function(x) path(full_path, x))
  }
  files
}
