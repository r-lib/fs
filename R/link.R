#' Link information
#' @inherit file_info
#' @export
link_info <- file_info

#' Create a file link
#' @template fs
#' @param new_path Character vector of locations the link should point to.
#' @param symbolic Boolean value determining if the link should be a symbolic
#' (the default) or hard link.
#' @export
link_create <- function(path, new_path, symbolic = TRUE) {
  path <- path_expand(path)
  new_path <- path_expand(new_path)

  stopifnot(length(path) == length(new_path))

  if (isTRUE(symbolic)) {
    link_create_symbolic_(path, new_path)
  } else {
    link_create_hard_(path, new_path)
  }

  invisible(new_path)
}

#' Read the value of a symbolic link
#' @template fs
#' @examples
#' file_create("foo")
#' link_create("foo", "bar")
#' link_path("bar")
#' file_delete(c("foo", "bar"))
#' @export
link_path <- function(path) {
  path <- path_expand(path)

  readlink_(path)
}
