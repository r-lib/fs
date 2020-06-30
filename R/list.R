#' List files
#'
#' @description
#' `dir_ls()` is equivalent to the `ls` command. It returns filenames as a
#' named `fs_path` character vector. The names are equivalent to the values,
#' which is useful for passing onto functions like `purrr::map_dfr()`.
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
#' @param recurse If `TRUE` recurse fully, if a positive number the number of levels
#'   to recurse.
#' @param recursive (Deprecated) If `TRUE` recurse fully.
#' @inheritParams path_filter
#' @param all If `TRUE` hidden files are also returned.
#' @param fail Should the call fail (the default) or warn if a file cannot be
#'   accessed.
#' @template fs
#' @export
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' dir_ls(R.home("share"), type = "directory")
#'
#' # Create a shorter link
#' link_create(system.file(package = "base"), "base")
#'
#' dir_ls("base", recurse = TRUE, glob = "*.R")
#'
#' dir_map("base", identity)
#'
#' dir_walk("base", str)
#'
#' dir_info("base")
#'
#' # Cleanup
#' link_delete("base")
#' \dontshow{setwd(.old_wd)}
dir_ls <- function(path = ".", all = FALSE, recurse = FALSE, type = "any",
                   glob = NULL, regexp = NULL, invert = FALSE, fail = TRUE,
                   ..., recursive) {
  assert_no_missing(path)

  if (!missing(recursive)) {
    recurse <- recursive
    warning("`recursive` is deprecated, please use `recurse` instead", immediate. = TRUE, call. = FALSE)
  }

  old <- path_expand(path)

  files <- as.character(dir_map(old, identity, all, recurse, type, fail))

  path_filter(files, glob, regexp, invert = invert, ...)
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
#' @export
dir_map <- function(path = ".", fun, all = FALSE, recurse = FALSE, type =
  "any", fail = TRUE) {
  assert_no_missing(path)

  if (is.logical(recurse)) {
    if (isTRUE(recurse)) {
      recurse <- -1
    } else {
      recurse <- 0
    }
  }

  type <- match.arg(type, names(directory_entry_types), several.ok = TRUE)

  old <- path_expand(path)

  .Call(fs_dir_map_, old, fun, all, sum(directory_entry_types[type]), as.integer(recurse), fail)
}

#' @rdname dir_ls
#' @export
dir_walk <- function(path = ".", fun, all = FALSE, recurse = FALSE, type = "any", fail = TRUE) {
  assert_no_missing(path)

  old <- path_expand(path)

  dir_map(old, fun, all, recurse, type, fail)
  invisible(path_tidy(path))
}

#' @rdname dir_ls
#' @export
dir_info <- function(path = ".", all = FALSE, recurse = FALSE,
                     type = "any", regexp = NULL, glob = NULL, fail = TRUE, ...) {
  assert_no_missing(path)

  file_info(dir_ls(path = path, all = all, recurse = recurse, type = type,
    regexp = regexp, glob = glob, fail = fail, ...), fail = fail)
}
