#' Delete a file, directory, or link.
#'
#' `dir_delete()` will first delete the contents of the directory, then remove
#' the directory.
#'
#' @template fs
#' @export
#' @return The deleted paths.
#' @name delete
#' @examples
#' \dontshow{fs:::pkgdown_tmp("/tmp/filedd4635bd7c86")}
#' x <- file_create(file_temp())
#' file_exists(x)
#' file_delete(x)
#' file_exists(x)
file_delete <- function(path) {
  path <- path_expand(path)
  unlink_(path)

  invisible(path_tidy(path))
}

#' @rdname delete
#' @export
dir_delete <- function(path) {
  dirs <- dir_list(path, type = "directory", recursive = TRUE)
  files <- dir_list(path,
    type = c("unknown", "file", "symlink", "FIFO", "socket", "character_device", "block_device"),
    recursive = TRUE)
  file_delete(files)
  rmdir_(rev(c(path, dirs)))

  invisible(path_tidy(path))
}

#' @rdname delete
#' @export
link_delete <- file_delete
