#' Functions to test for file types
#'
#' @return A named logical vector, where the names give the paths. If the given
#'   object does not exist, `NA` is returned.
#' @seealso [file_exists()], [dir_exists()] and [link_exists()] if you want
#'   to ensure that the path also exists.
#' @template fs
#' @importFrom stats setNames
#' @export
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' dir_create("d")
#'
#' file_create("d/file.txt")
#' dir_create("d/dir")
#' link_create(path(path_abs("d"), "file.txt"), "d/link")
#'
#' paths <- dir_ls("d")
#' is_file(paths)
#' is_dir(paths)
#' is_link(paths)
#'
#' # Cleanup
#' dir_delete("d")
#' \dontshow{setwd(.old_wd)}
is_file <- function(path) {
  res <- file_info(path)
  setNames(!is.na(res$type) & res$type == "file", res$path)
}

#' @rdname is_file
#' @export
is_dir <- function(path) {
  res <- file_info(path)
  setNames(!is.na(res$type) & res$type == "directory", res$path)
}

#' @rdname is_file
#' @export
is_link <- function(path) {
  res <- file_info(path)
  setNames(!is.na(res$type) & res$type == "symlink", res$path)
}

#' @rdname is_file
#' @export
is_file_empty <- function(path) {
  res <- file_info(path)

  setNames(!is.na(res$size) & res$size == 0, res$path)
}

#' Test if a path is an absolute path
#'
#' @template fs
#' @export
#' @examples
#' is_absolute_path("/foo")
#' is_absolute_path("C:\\foo")
#' is_absolute_path("\\\\myserver\\foo\\bar")
#'
#' is_absolute_path("foo/bar")
is_absolute_path <- function(path) {
  tidy_path <- path_tidy(path)
  grepl("^~", path) | grepl("^(/+|[A-Za-z]:)", tidy_path)
}
