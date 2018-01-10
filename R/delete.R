#' Delete files, directories, or links
#'
#' @description
#' `file_delete()` and `link_delete()` delete file and links. Compared to
#' [file.remove] they always fail if they cannot delete the object rather than
#' changing return value or signalling a warning.
#'
#' `dir_delete()` will first delete the contents of the directory, then remove
#' the directory. Compared to [unlink] it will always throw an error if the
#' directory cannot be deleted rather than being silent or signalling a warning.
#' @template fs
#' @export
#' @return The deleted paths (invisibly).
#' @name delete
#' @examples
#' \dontshow{fs:::pkgdown_tmp("/tmp/filedd4635bd7c86")}
#' # create a directory, with some files and a link to it
#' dir <- dir_create(file_temp())
#' files <- file_create(path(dir, letters[1:5]))
#' link <- link_create(path_norm(dir), "link")
#'
#' # All files created
#' dir_exists(dir)
#' file_exists(files)
#' link_exists(link)
#' file_exists(link_path(link))
#'
#' # Delete a file
#' file_delete(files[1])
#' file_exists(files[1])
#'
#' # Delete the directory (which deletes the files as well)
#' dir_delete(dir)
#' file_exists(files)
#' dir_exists(dir)
#'
#' # The link still exists, but what it points to does not.
#' link_exists(link)
#' dir_exists(link_path(link))
#'
#' # Delete the link
#' link_delete(link)
#' link_exists(link)
file_delete <- function(path) {
  path <- path_expand(path)
  unlink_(path)

  invisible(path_tidy(path))
}

#' @rdname delete
#' @export
dir_delete <- function(path) {
  dirs <- dir_ls(path, type = "directory", recursive = TRUE)
  files <- dir_ls(path,
    type = c("unknown", "file", "symlink", "FIFO", "socket", "character_device", "block_device"),
    recursive = TRUE)
  file_delete(files)
  rmdir_(rev(c(path, dirs)))

  invisible(path_tidy(path))
}

#' @rdname delete
#' @export
link_delete <- file_delete
