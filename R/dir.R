#' Move a directory
#'
#' @inherit file_move
#' @include file.R
#' @export
dir_move <- file_move

#' Directory information
#' @inherit file_info
#' @export
dir_info <- file_info

#' Create a directory
#' @inheritParams file_create
#' @param recursive Should intermediate directories be created recursively if
#'   they don't exist?
#' @examples
#' x <- tempfile()
#' try(is_dir(x))
#' dir_create(x)
#' is_dir(x)
#' @export
dir_create <- function(path, mode = "u+rwx,go+rx", recursive = TRUE) {
  paths <- path_split(path)
  if (length(paths) == 1 || !isTRUE(recursive)) {
    mkdir_(path, mode)
    return(invisible(path))
  }
  else {
    dir_create(Reduce(file.path, paths, accumulate = TRUE), mode = mode)
  }

  invisible(path)
}

#' Delete files in a directory
#'
#' @inheritParams dir_list
#' @export
dir_delete <- function(path) {
  dirs <- dir_list(path, type = "directory")
  files <- setdiff(dir_list(path, type = "any"), dirs)
  file_delete(files)
  rmdir_(rev(c(path, dirs)))

  invisible(path)
}
