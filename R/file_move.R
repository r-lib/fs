#' Move a file
#'
#' @template fs
#' @param new_path new file path
#' @export
file_move <- function(path, new_path) {
  path <- path_expand(path)
  new_path <- path_expand(new_path)

  is_directory <- file_exists(new_path) && is_dir(new_path)

  if (length(new_path) == 1 && is_directory[[1]]) {
    new_path <- rep(new_path, length(path))
  }
  stopifnot(length(path) == length(new_path))

  new_path[is_directory] <- path(new_path[is_directory], basename(path))

  move_(path, new_path)

  invisible(new_path)
}
