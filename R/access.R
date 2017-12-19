access_types <- c("exists" = 0L, "read" = 4L, "write" = 2L, "execute" = 1L)

#' Query for existence and access permissions
#'
#' `file_exists(path)` is a shortcut for `file_access(x, "exists")`;
#' `dir_exists(path)` and `link_exists(path)` are similar but also checks that
#' the path is a directory or link, respectively.
#'
#' @template fs
#' @param mode A character vector containing one or more of 'exists', 'read',
#'   'write', 'execute'.
#' @return A logical vector, with names giving paths
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

  access_(path, mode)
}

#' @rdname file_access
#' @export
file_exists <- function(path) {
  file_access(path, "exists")
}

#' @rdname file_access
#' @export
dir_exists <- function(path) {
  file_exists(path) && is_dir(path)
}

#' @rdname file_access
#' @export
link_exists <- function(path) {
  file_exists(path) && is_link(path)
}
