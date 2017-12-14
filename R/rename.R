#' Rename a file
#'
#' @param path file path
#' @param new_path new file path
#' @export
file_rename <- function(path, new_path) {
  file_rename_(normalizePath(enc2utf8(path)), normalizePath(enc2utf8(new_path), mustWork = FALSE))
}
