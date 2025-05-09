#' Create files, directories, or links
#'
#' The functions `file_create()` and `dir_create()` ensure that `path` exists;
#' if it already exists it will be left unchanged. That means that compared to
#' [file.create()], `file_create()` will not truncate an existing file, and
#' compared to [dir.create()], `dir_create()` will silently ignore existing
#' directories.
#'
#' @param path A character vector of one or more paths. For `link_create()`,
#'   this is the target.
#' @param mode If file/directory is created, what mode should it have?
#'
#'   Links do not have mode; they inherit the mode of the file they link to.
#' @param recurse should intermediate directories be created if they do not
#'   exist?
#' @param recursive (Deprecated) If `TRUE` recurse fully.
#' @param ... Additional arguments passed to [path()]
#' @return The path to the created object (invisibly).
#' @name create
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' file_create("foo")
#' is_file("foo")
#' # dir_create applied to the same path will fail
#' try(dir_create("foo"))
#'
#' dir_create("bar")
#' is_dir("bar")
#' # file_create applied to the same path will fail
#' try(file_create("bar"))
#'
#' # Cleanup
#' file_delete("foo")
#' dir_delete("bar")
#' \dontshow{setwd(.old_wd)}
#' @export
file_create <- function(path, ..., mode = "u=rw,go=r") {
  assert_no_missing(path)
  assert("`mode` must be of length 1", length(mode) == 1)

  mode <- as_fs_perms(mode)
  new <- path_expand(path(path, ...))

  .Call(fs_create_, new, as.integer(mode))
  invisible(path_tidy(new))
}

#' @export
#' @rdname create
dir_create <- function(
  path,
  ...,
  mode = "u=rwx,go=rx",
  recurse = TRUE,
  recursive
) {
  assert_no_missing(path)
  assert("`mode` must be of length 1", length(mode) == 1)

  if (!missing(recursive)) {
    recurse <- recursive
    warning(
      "`recursive` is deprecated, please use `recurse` instead",
      immediate. = TRUE,
      call. = FALSE
    )
  }

  mode <- as_fs_perms(mode)
  new <- path_expand(path(path, ...))

  if (!isTRUE(recurse)) {
    .Call(fs_mkdir_, new, as.integer(mode))
    return(invisible(path_tidy(new)))
  }

  paths <- path_split(new)
  for (p in paths) {
    if (length(p) == 1) {
      .Call(fs_mkdir_, p, as.integer(mode))
    } else {
      p_paths <- Reduce(get("path", mode = "function"), p, accumulate = TRUE)
      if (is_absolute_path(p[[1]])) {
        p_paths <- p_paths[-1]
      }
      .Call(fs_mkdir_, p_paths, as.integer(mode))
    }
  }

  invisible(path_tidy(new))
}

#' @export
#' @rdname create
#' @param new_path The path where the link should be created.
#' @param symbolic Boolean value determining if the link should be a symbolic
#'   (the default) or hard link.
link_create <- function(path, new_path, symbolic = TRUE) {
  assert_no_missing(path)
  assert_no_missing(new_path)
  assert(
    "Length of `path` must equal length of `new_path`",
    length(path) == length(new_path)
  )

  old <- path_expand(path)
  new <- path_expand(new_path)

  if (isTRUE(symbolic)) {
    .Call(fs_link_create_symbolic_, old, new)
  } else {
    .Call(fs_link_create_hard_, old, new)
  }

  invisible(path_tidy(new_path))
}
