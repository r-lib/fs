#' List files in a directory
#'
#' @param type File type(s) to return, one or more of "any", "file", "directory",
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
dir_list <- function(path = ".", all = FALSE, recursive = FALSE, type = "any", pattern = NULL, ...) {
  type <- match.arg(type, names(directory_entry_types), several.ok = TRUE)

  path <- path_expand(path)

  files <- scandir_(path, isTRUE(all), sum(directory_entry_types[type]), recursive)
  if (!is.null(pattern)) {
    files <- grep(x = files, pattern = pattern, value = TRUE, ...)
  }
  path_tidy(files)
}

directory_entry_types <- c(
  "any" = -1L,
  "unknown" = 1L,
  "file" = 2L,
  "directory" = 4L,
  "symlink" = 8L,
  "FIFO" = 16L,
  "socket" = 32L,
  "character_device" = 64L,
  "block_device" = 128L)

#' @describeIn dir_list Walk along a directory, calling `f` for each entry in
#'   the directory.
#' @param fun A function, taking one parameter, the current path entry.
#' @examples
#' dir_walk(system.file(), function(p) if (grepl("profile", p)) print(p))
#' @export
dir_walk <- function(path = ".", fun, all = FALSE, recursive = FALSE, type = "any", pattern = NULL, ...) {
  type <- match.arg(type, names(directory_entry_types), several.ok = TRUE)

  path <- path_expand(path)

  dir_walk_(path, fun, all, sum(directory_entry_types[type]), recursive)
}

#' @describeIn dir_list A shortcut for the combination of `file_info(dir_list())`.
#' @export
dir_info <- function(path = ".", all = FALSE, recursive = FALSE, type = "any", pattern = NULL, ...) {
  file_info(dir_list(path = path, all = all, recursive = recursive, type = type, pattern = pattern, ...))
}
