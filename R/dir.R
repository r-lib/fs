#' Copy a directory
#' @template fs
#' @param new_path new location to copy to.
dir_copy <- function(path, new_path) {
  path <- path_expand(path)
  new_path <- path_expand(new_path)

  stopifnot(is_dir(path))
  stopifnot(!dir_exists(new_path))

  dirs <- dir_list(path, type = "directory", recursive = TRUE)

  # Remove first path from directories and prepend new path
  new_dirs <- path(new_path, sub("[^/]*/", "", dirs))
  dir_create(c(new_path, new_dirs))

  files <- dir_list(path,
    type = c("unknown", "file", "symlink", "FIFO", "socket", "character_device", "block_device")
    , recursive = TRUE)

  # Remove first path from files and prepend new path
  new_files <- path(new_path, sub("[^/]*/", "", files))
  file_copy(files, new_files)

  invisible(path_tidy(new_path))
}
