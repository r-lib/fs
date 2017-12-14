#' Rename a file
#'
#' @param path file path
#' @param new_path new file path
#' @export
fs_move <- function(path, new_path) {
  path <- enc2utf8(path)
  new_path <- enc2utf8(new_path)

  # Expand only the directory portion of new_path
  new_path <- file.path(dirname(fs_expand(new_path)), basename(new_path))

  rename_(fs_realpath(fs_expand(path)), new_path)
}
