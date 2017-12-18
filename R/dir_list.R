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
