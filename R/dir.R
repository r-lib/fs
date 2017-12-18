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
#' @param recursive Should intermediate directories be created recursively if
#'   they don't exist?
#' @examples
#' x <- tempfile()
#' try(is_dir(x))
#' dir_create(x)
#' is_dir(x)
#' @export
dir_create <- function(path, mode = "u+rwx,go+rx", recursive = TRUE) {
  paths <- path_split(path)
  if (length(paths) == 1 || !isTRUE(recursive)) {
    mkdir_(path, mode)
    return(invisible(path))
  }
  else {
    dir_create(Reduce(file.path, paths, accumulate = TRUE), mode = mode)
  }

  invisible(path)
}

#' List files in a directory
#'
#' @param type File type to return, one of "any", "file", "directory",
#'   "symlink", "FIFO", "socket", "character_device" or "block_device".
#' @param recursive Should directories be listed recursively?
#' @param pattern A regular expression pattern used passed to [grep] to filter
#'   the filenames.
#' @param ... Additional arguments passed to [grep].
#' @template fs
#' @export
#' @examples
#' dir_list(system.file())
dir_list <- function(path = ".", recursive = TRUE, type = "any", pattern = NULL, ...) {
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
  if (!is.null(pattern)) {
    files <- grep(x = files, pattern = pattern, value = TRUE, ...)
  }
  files
}

#' Delete files in a directory
#'
#' @inheritParams dir_list
#' @export
dir_delete <- function(path) {
  dirs <- dir_list(path, type = "directory")
  files <- setdiff(dir_list(path, type = "any"), dirs)
  file_delete(files)
  rmdir_(rev(c(path, dirs)))

  invisible(path)
}
