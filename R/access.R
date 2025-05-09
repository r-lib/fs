access_types <- c("exists" = 0L, "read" = 4L, "write" = 2L, "execute" = 1L)

#' Query for existence and access permissions
#'
#' * `file_exists(path)` is a shortcut for `file_access(x, "exists")`
#' * `dir_exists(path)` and `link_exists(path)` are similar but also check that
#'   the path is a directory or link, respectively. (`file_exists(path)` returns
#'   `TRUE` if `path` exists and it is a directory. Use [is_file()] to check for
#'   file (not directory) existence)
#'
#' @template fs
#' @param mode A character vector containing one or more of 'exists', 'read',
#'   'write', 'execute'.
#' @details **Cross-compatibility warning:** There is no executable bit on
#'   Windows. Checking a file for mode 'execute' on Windows, e.g.
#'   `file_access(x, "execute")` will always return `TRUE`.
#' @return A logical vector, with names corresponding to the input `path`.
#' @export
#' @examples
#' file_access("/")
#' file_access("/", "read")
#' file_access("/", "write")
#'
#' file_exists("WOMBATS")
file_access <- function(path, mode = "exists") {
  assert_no_missing(path)
  mode <- match.arg(mode, names(access_types), several.ok = TRUE)

  old <- path_expand(path)
  mode <- sum(access_types[mode])

  .Call(fs_access_, unclass(old), as.integer(mode))
}

#' @rdname file_access
#' @export
file_exists <- function(path) {
  old <- path_expand(path)
  .Call(fs_exists_, old, path)
}

#' @rdname file_access
#' @export
dir_exists <- function(path) {
  res <- is_dir(path)

  links <- is_link(path)
  res[links] <- is_dir(path_real(path[links]))

  !is.na(res) & res
}

#' @rdname file_access
#' @export
link_exists <- function(path) {
  res <- is_link(path)
  !is.na(res) & res
}
