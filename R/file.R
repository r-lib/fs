#' Rename a file
#'
#' @template fs
#' @param new_path new file path
#' @export
file_move <- function(path, new_path) {
  path <- enc2utf8(path)
  new_path <- enc2utf8(new_path)

  stopifnot(length(path) == length(new_path))

  # Expand only the directory portion of new_path
  new_path <- path(dirname(path_expand(new_path)), basename(new_path))

  move_(path_norm(path_expand(path)), new_path)

  invisible(new_path)
}
