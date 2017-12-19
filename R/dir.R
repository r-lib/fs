#' Move a directory
#'
#' @inherit file_move
#' @include file_move.R
#' @export
dir_move <- file_move

#' Directory information
#' @inherit file_info
#' @include file.R
#' @export
dir_info <- file_info

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


#' Check if a directory exists
#' @template fs
#' @export
dir_exists <- function(path) {
  file_exists(path) && is_dir(path)
}
