#' List files in a directory
#'
#' @param type File type to return, one of "any", "file", "directory",
#'   "symlink", "FIFO", "socket", "character_device" or "block_device".
#' @param recursive Should directories be listed recursively?
#' @param pattern A regular expression pattern used passed to [grep] to filter
#'   the filenames.
#' @param all If `TRUE` hidden files are also returned.
#' @param ... Additional arguments passed to [grep].
#' @template fs
#' @export
#' @examples
#' dir_list(system.file())
dir_list <- function(path = ".", all = FALSE, recursive = TRUE, type = "any", pattern = NULL, ...) {

  type <- match.arg(type, names(directory_entry_types))

  path <- path_expand(path)

  files <- scandir_(path, isTRUE(all), directory_entry_types[type], recursive)
  if (!is.null(pattern)) {
    files <- grep(x = files, pattern = pattern, value = TRUE, ...)
  }
  files
}

directory_entry_types <- c(
  "any" = -1L,
  "file" = 1L,
  "directory" = 2L,
  "symlink" = 3L,
  "FIFO" = 4L,
  "socket" = 5L,
  "character_device" = 6L,
  "block_device" = 7L)

#' @describeIn dir_list Walk along a directory, calling `f` for each entry in
#'   the directory.
#' @param f A function, taking one parameter, the current path entry.
#' @examples
#' dir_walk(system.file(), function(p) if (grepl("profile", p)) print(p))
#' @export
dir_walk <- function(path = ".", f, all = FALSE, recursive = TRUE, type = "any", pattern = NULL, ...) {
  type <- match.arg(type, names(directory_entry_types))

  path <- path_expand(path)

  dir_walk_(path, f, all, directory_entry_types[type], recursive)
}
