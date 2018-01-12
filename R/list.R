#' List files
#'
#' @description
#' `dir_ls()` is equivalent to the `ls` command. It returns filenames as a
#' `fs_path` character vector.
#'
#' `dir_info()` is equivalent to `ls -l` and a shortcut for
#' `file_info(dir_ls())`.
#'
#' `dir_map()` applies a function `fun()` to each entry in the path and returns
#' the result in a list.
#'
#' `dir_walk()` calls `fun` for its side-effect and returns the input `path`.
#'
#' @param type File type(s) to return, one or more of "any", "file", "directory",
#'   "symlink", "FIFO", "socket", "character_device" or "block_device".
#' @param recursive Should directories be listed recursively?
#'   the filenames.
#' @inheritParams path_filter
#' @param all If `TRUE` hidden files are also returned.
#' @template fs
#' @export
#' @examples
#' dir_ls(R.home("share"), type = "directory")
#'
#' link_create(system.file(package = "base"), "base")
#'
#' dir_ls("base", recursive = TRUE, glob = "*.R")
dir_ls <- function(path = ".", all = FALSE, recursive = FALSE, type = "any",
                   glob = NULL, regexp = NULL, invert = FALSE, ...) {
  files <- as.character(dir_map(path, identity, all, recursive, type))

  path_filter(files, glob, regexp, ...)
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

#' @rdname dir_ls
#' @param fun A function, taking one parameter, the current path entry.
#' @examples
#' dir_map("base", identity)
#' @export
dir_map <- function(path = ".", fun, all = FALSE, recursive = FALSE, type = "any") {
  type <- match.arg(type, names(directory_entry_types), several.ok = TRUE)

  path <- path_expand(path)

  dir_map_(path, fun, all, sum(directory_entry_types[type]), recursive)
}

#' @rdname dir_ls
#' @examples
#' dir_walk("base", str)
#' @export
dir_walk <- function(path = ".", fun, all = FALSE, recursive = FALSE, type = "any") {
  dir_map(path, fun, all, recursive, type)
  invisible(path_tidy(path))
}

#' @rdname dir_ls
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

