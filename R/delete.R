#' Delete files, directories, or links
#'
#' @description
#' `file_delete()` and `link_delete()` delete file and links. Compared to
#' [file.remove] they always fail if they cannot delete the object rather than
#' changing return value or signalling a warning. If any inputs are
#' directories, they are passed to `dir_delete()`, so `file_delete()` can
#' therefore be used to delete any filesystem object.
#'
#' `dir_delete()` will first delete the contents of the directory, then remove
#' the directory. Compared to [unlink] it will always throw an error if the
#' directory cannot be deleted rather than being silent or signalling a warning.
#' @template fs
#' @export
#' @return The deleted paths (invisibly).
#' @name delete
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' # create a directory, with some files and a link to it
#' dir_create("dir")
#' files <- file_create(path("dir", letters[1:5]))
#' link <- link_create(path_abs("dir"), "link")
#'
#' # All files created
#' dir_exists("dir")
#' file_exists(files)
#' link_exists("link")
#' file_exists(link_path("link"))
#'
#' # Delete a file
#' file_delete(files[1])
#' file_exists(files[1])
#'
#' # Delete the directory (which deletes the files as well)
#' dir_delete("dir")
#' file_exists(files)
#' dir_exists("dir")
#'
#' # The link still exists, but what it points to does not.
#' link_exists("link")
#' dir_exists(link_path("link"))
#'
#' # Delete the link
#' link_delete("link")
#' link_exists("link")
#' \dontshow{setwd(.old_wd)}
file_delete <- function(path) {
  assert_no_missing(path)

  old <- path_expand(path)

  dirs <- is_dir(old)
  dir_delete(old[dirs])

  .Call(fs_unlink_, old[!dirs])

  invisible(path_tidy(path))
}

#' @rdname delete
#' @export
dir_delete <- function(path) {
  assert_no_missing(path)

  old <- path_expand(path)

  dirs <- dir_ls(old, type = "directory", recurse = TRUE, all = TRUE)
  files <- dir_ls(old,
    type = c("unknown", "file", "symlink", "FIFO", "socket", "character_device", "block_device"),
    recurse = TRUE,
    all = TRUE)
  .Call(fs_unlink_, files)
  .Call(fs_rmdir_, rev(c(old, dirs)))

  invisible(path_tidy(path))
}

#' @rdname delete
#' @export
link_delete <- function(path) {
  assert_no_missing(path)

  assert("`path` must be a link",
    all(is_link(path))
  )

  old <- path_expand(path)

  .Call(fs_unlink_, old)

  invisible(path_tidy(path))
}
