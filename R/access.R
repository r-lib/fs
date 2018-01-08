access_types <- c("exists" = 0L, "read" = 4L, "write" = 2L, "execute" = 1L)

#' Query for existence and access permissions
#'
#' `file_exists(path)` is a shortcut for `file_access(x, "exists")`;
#' `dir_exists(path)` and `link_exists(path)` are similar but also check that
#' the path is a directory or link, respectively.
#'
#' @template fs
#' @param mode A character vector containing one or more of 'exists', 'read',
#'   'write', 'execute'.
#' @return A logical vector, with names corresponding to the input `path`.
#' @export
#' @examples
#' file_access("/")
#' file_access("/", "read")
#' file_access("/", "write")
#'
#' file_exists("WOMBATS")
file_access <- function(path, mode = "exists") {
  path <- path_expand(path)
  mode <- match.arg(mode, names(access_types), several.ok = TRUE)
  mode <- sum(access_types[mode])

  access_(unclass(path), mode)
}

#' @rdname file_access
#' @export
file_exists <- function(path) {
  res <- file_info(path)
  setNames(!is.na(res$type), res$path)
}

#' @rdname file_access
#' @export
dir_exists <- function(path) {
  res <- is_dir(path)
  !is.na(res) & res
}

#' @rdname file_access
#' @export
link_exists <- function(path) {
  res <- is_link(path)
  !is.na(res) & res
}
