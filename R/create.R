#' Create a file, directory, or link.
#'
#' These functions ensure that `path` exists; if it already exists it will
#' be left unchanged. That means that ompared to [file.create()],
#' `file_create()` will not truncate an existing, and compared to
#' [dir.create()], `dir_create()` will silently ignore
#' existing directories.
#'
#' @template fs
#' @param mode If file/directory is created, what mode should it have?
#' @param recursive should intermediate directories be created if they do not
#'   exist?
#' @examples
#' x <- file_create(tempfile())
#' is_file(x)
#' # dir_create applied to the same path will fail
#' try(dir_create(x))
#'
#' x <- dir_create(tempfile())
#' is_dir(x)
#' # file_create applied to the same path will fail
#' try(file_create(x))
#' @export
dir_create <- function(path, mode = "u+rwx,go+rx", recursive = TRUE) {
  paths <- path_split(path)
  for (p in paths) {
    if (length(p) == 1 || !isTRUE(recursive)) {
      mkdir_(p, mode)
    }
    else {
      mkdir_(Reduce(file.path, p, accumulate = TRUE), mode)
    }
  }

  invisible(path)
}

#' @export
#' @rdname dir_create
file_create <- function(path, mode = "u+rw,go+r") {
  stopifnot(length(mode) == 1)

  create_(path_expand(path), mode)
  invisible(path)
}

#' @export
#' @rdname dir_create
#' @param symbolic Boolean value determining if the link should be a symbolic
#'   (the default) or hard link.
link_create <- function(path, new_path, symbolic = TRUE) {
  path <- path_expand(path)
  new_path <- path_expand(new_path)

  stopifnot(length(path) == length(new_path))

  if (isTRUE(symbolic)) {
    link_create_symbolic_(path, new_path)
  } else {
    link_create_hard_(path, new_path)
  }

  invisible(new_path)
}
