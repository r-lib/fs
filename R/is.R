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
#' \dontshow{fs:::pkgdown_tmp("/tmp/filedd46c01c6ad")}
#' tmp <- dir_create(file_temp())
#'
#' file_create(path(tmp, "file.txt"))
#' dir_create(path(tmp, "dir"))
#' link_create(path(tmp, "file.txt"), path(tmp, "link"))
#'
#' paths <- dir_list(tmp)
#' is_file(paths)
#' is_dir(paths)
#' is_link(paths)
is_file <- function(path) {
  res <- file_info(path)
  setNames(res$type == "file", res$path)
}

#' @rdname is_file
#' @export
is_dir <- function(path) {
  res <- file_info(path)
  setNames(res$type == "directory", res$path)
}

#' @rdname is_file
#' @export
is_link <- function(path) {
  res <- file_info(path)
  setNames(res$type == "symlink", res$path)
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
