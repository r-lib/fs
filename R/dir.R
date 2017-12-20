#' Delete files in a directory
#'
#' @inheritParams dir_list
#' @export
dir_delete <- function(path) {
  dirs <- dir_list(path, type = "directory")
  files <- dir_list(path, type = c("unknown", "file", "symlink", "FIFO", "socket", "character_device", "block_device"))
  file_delete(files)
  rmdir_(rev(c(path, dirs)))

  invisible(path)
}

#' Copy a directory
#' @template fs
#' @param new_path new location to copy to.
dir_copy <- function(path, new_path) {
  path <- path_expand(path)
  new_path <- path_expand(new_path)

  stopifnot(is_dir(path))
  stopifnot(!dir_exists(new_path))

  dirs <- dir_list(path, type = "directory")
  dir_create(c(new_path, dirs))
  files <- dir_list(path, type = c("unknown", "file", "symlink", "FIFO", "socket", "character_device", "block_device"))

  # Remove first path from filenames and prepend new path
  new_files <- path(new_path, sub(".*/", "", files))

  file_copy(files, new_files)

  invisible(new_path)
}
