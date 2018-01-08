#' Move or rename files
#'
#' Compared to [file.rename] `file_move()` always fails if it is unable to move
#' a file, rather than signaling a Warning and returning an error code.
#' @template fs
#' @param new_path New file path. If `new_path` is existing directory, the file
#'   will be moved into that directory; otherwise it will be moved/renamed to
#'   the full path.
#'
#'   Should either be the same length as `path`, or a single directory.
#' @return The new path (invisibly).
#' @examples
#' file_create("foo")
#' file_move("foo", "bar")
#' file_exists(c("foo", "bar"))
#' file_delete("bar")
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

  invisible(path_tidy(new_path))
}
