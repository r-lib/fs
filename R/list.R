#' List files
#'
#' `dir_ls()` is equivalent to the `ls` command. `dir_info()` is equivalent to
#' `ls -l`.
#' @param type File type(s) to return, one or more of "any", "file", "directory",
#'   "symlink", "FIFO", "socket", "character_device" or "block_device".
#' @param glob,regexp Either a file glob (e.g. `*.csv`) or a regular
#'   expression (e.g. `\\.csv$)` passed on to [grep] to filter paths.
#' @param recursive Should directories be listed recursively?
#'   the filenames.
#' @param all If `TRUE` hidden files are also returned.
#' @param ... Additional arguments passed to [grep].
#' @template fs
#' @export
#' @examples
#' dir_ls(R.home("share"), type = "directory")
#'
#' link_create(system.file(package = "base"), "base")
#'
#' dir_ls("base", recursive = TRUE, glob = "*.R")
dir_ls <- function(path = ".", all = FALSE, recursive = FALSE,
                     type = "any", regexp = NULL, glob = NULL, ...) {
  type <- match.arg(type, names(directory_entry_types), several.ok = TRUE)

  path <- path_expand(path)

  files <- scandir_(path, isTRUE(all), sum(directory_entry_types[type]), recursive)

  if (!is.null(glob)) {
    regexp <- utils::glob2rx(glob)
  }
  if (!is.null(regexp)) {
    files <- grep(x = files, pattern = regexp, value = TRUE, ...)
  }
  setNames(path_tidy(files), files)
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

#' @describeIn dir_ls Walk along a directory, calling `f` for each entry in
#'   the directory.
#' @param fun A function, taking one parameter, the current path entry.
#' @examples
#' dir_walk(system.file(), str)
#' @export
dir_walk <- function(path = ".", fun, all = FALSE, recursive = FALSE, type = "any") {
  type <- match.arg(type, names(directory_entry_types), several.ok = TRUE)

  path <- path_expand(path)

  dir_walk_(path, fun, all, sum(directory_entry_types[type]), recursive)
}

#' @describeIn dir_ls A shortcut for the combination of `file_info(dir_ls())`.
#' @export
#' @examples
#' dir_info("base")
#'
#' # Cleanup
#' link_delete("base")
dir_info <- function(path = ".", all = FALSE, recursive = FALSE,
                     type = "any", regexp = NULL, glob = NULL, ...) {
  file_info(dir_ls(path = path, all = all, recursive = recursive, type = type,
    regexp = regexp, glob = glob, ...))
}

