#' Rename a file
#'
#' @param path file path
#' @param new_path new file path
#' @export
file_rename <- function(path, new_path) {
  path <- enc2utf8(path)
  new_path <- enc2utf8(new_path)

  # Expand only the directory portion of new_path
  new_path <- file.path(dirname(file_expand(new_path)), basename(new_path))

  file_rename_(file_realpath(file_expand(path)), new_path)
}
