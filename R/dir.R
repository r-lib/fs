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
#' @param type File type to return, one of "any", "file", "directory",
#'   "symlink", "FIFO", "socket", "character_device" or "block_device".
#' @param recursive Should directories be listed recursively?
#' @template fs
#' @export
#' @examples
#' dir_list(system.file())
dir_list <- function(path, recursive = TRUE, type = "any") {
  # TODO: actually implement recursion
  directory_entry_types <- c(
    "any" = -1L,
    "file" = 1L,
    "directory" = 2L,
    "symlink" = 3L,
    "FIFO" = 4L,
    "socket" = 5L,
    "character_device" = 6L,
    "block_device" = 7L)

  type <- match.arg(type, names(directory_entry_types))

  path <- path_expand(path)

  files <- scandir_(path, directory_entry_types[type], recursive)
  files
}
