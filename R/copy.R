#' Copy files, directories or links
#'
#' @description
#' `file_copy()` copies files.
#'
#' `link_copy()` creates a new link pointing to the same location as the previous link.
#'
#' `dir_copy()` copies the directory recursively at the new location.
#' @param new_path A character vector of paths to the new locations.
#' @param overwrite Overwrite files if they exist. If this is `FALSE` and the
#'   file exists an error will be thrown.
#' @template fs
#' @return The new path (invisibly).
#' @name copy
#' @export
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' file_create("foo")
#' file_copy("foo", "bar")
#' try(file_copy("foo", "bar"))
#' file_copy("foo", "bar", overwrite = TRUE)
#' file_delete(c("foo", "bar"))
#'
#' dir_create("foo")
#' # Create a directory and put a few files in it
#' files <- file_create(c("foo/bar", "foo/baz"))
#' file_exists(files)
#'
#' # Copy the directory
#' dir_copy("foo", "foo2")
#' file_exists(path("foo2", path_file(files)))
#'
#' # Create a link to the directory
#' link_create(path_abs("foo"), "loo")
#' link_path("loo")
#' link_copy("loo", "loo2")
#' link_path("loo2")
#'
#' # Cleanup
#' dir_delete(c("foo", "foo2"))
#' link_delete(c("loo", "loo2"))
#' \dontshow{setwd(.old_wd)}
file_copy <- function(path, new_path, overwrite = FALSE) {
  # TODO: copy attributes, e.g. cp -p?
  assert_no_missing(path)
  assert_no_missing(new_path)

  old <- path_expand(path)
  new <- path_expand(new_path)

  is_directory <- file_exists(new) & is_dir(new)

  if (length(new) == 1 && is_directory[[1]]) {
    new <- rep(new, length(path))
  }
  assert("Length of `path` must equal length of `new_path`", length(old) == length(new))

  new[is_directory] <- path(new[is_directory], basename(old))

  copyfile_(old, new, isTRUE(overwrite))

  invisible(path_tidy(new))
}

#' @rdname copy
#' @export
dir_copy <- function(path, new_path) {
  assert_no_missing(path)
  assert_no_missing(new_path)
  assert("`path` must be a directory", all(is_dir(path)))
  assert("Length of `path` must equal length of `new_path`", length(path) == length(new_path))

  for (i in seq_along(path)) {
    if (isTRUE(unname(is_dir(new_path[[i]])))) {
      new_path[[i]] <- path(new_path[[i]], path_file(path))
    }
    dir_create(new_path[[i]])

    dirs <- dir_ls(path[[i]], type = "directory", recurse = TRUE, all = TRUE)
    dir_create(path(new_path[[i]], path_rel(dirs, path[[i]])))

    files <- dir_ls(path, recurse = TRUE,
      type = c("unknown", "file", "FIFO", "socket", "character_device", "block_device"), all = TRUE)
    file_copy(files, path(new_path[[i]], path_rel(files, path[[i]])))

    links <- dir_ls(path, recurse = TRUE,
      type = "symlink", all = TRUE)
    link_copy(links, path(new_path[[i]], path_rel(links, path[[i]])))
  }

  invisible(path_tidy(new_path))
}

#' @rdname copy
#' @export
link_copy <- function(path, new_path, overwrite = FALSE) {
  assert_no_missing(path)
  assert_no_missing(new_path)
  stopifnot(all(is_link(path)))

  old <- path_expand(path)
  new <- path_expand(new_path)

  to_delete <- isTRUE(overwrite) & link_exists(new)
  if (any(to_delete)) {
    link_delete(new[to_delete])
  }

  invisible(link_create(link_path(old), new))
}
