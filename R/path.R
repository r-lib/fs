#' Construct path to a file or directory
#'
#' @template fs
#' @param ... character vectors
#' @export
#' @seealso [base::file.path()]
path <- function(...) {
  path_tidy(enc2utf8(file.path(..., fsep = "/")))
}

#' Return the canonicalized absolute pathname
#'
#' This is functionally equivalent to [base::normalizePath()].
#'
#' @template fs
#' @return `[character(1)]` the fully resolved path.
#' @export
path_norm <- function(path) {
  path <- enc2utf8(path)

  path_tidy(normalize_(path_expand(path)))
}


#' Perform tilde expansion of a pathname
#'
#' equivalent to [base::path.expand]
#' @template fs
#' @export
# TODO: so far it looks like libuv does not provide a cross platform version of
# this https://github.com/libuv/libuv/issues/11
path_expand <- function(path) {
  path <- enc2utf8(path)

  new_fs_path(path.expand(path))
}

#' Tidy paths
#'
#' untidy paths are all different, tidy paths are all the same.
#' Tidy paths always expand `~`, use `/` to delimit directories, never have
#' multiple `/` or trailing `/` and have colourised output based on the file
#' type.
#'
#' @return A fs_path object
#' @template fs
#' @export
path_tidy <- function(path) {
  path <- path_expand(path)

  # convert `\\` to `/`
  path <- gsub("\\", "/", path, fixed = TRUE)

  # convert multiple // to single /, as long as they are not at the start (when
  # they could be UNC paths).
  path <- gsub("(?<!^)//+", "/", path, perl = TRUE)

  # Remove trailing / from paths (that aren't also the beginning)
  path <- sub("(?<!^)/$", "", path, perl = TRUE)

  new_fs_path(path)
}


#' Split a path into components
#'
#' @template fs
#' @return A list of separated paths
#' @export
path_split <- function(path) {
  path <- path_tidy(path)

  # Split drive / UNC parts
  strsplit(path, "(?<!^)(?<!^/)/+", perl = TRUE)
}


#' Paths starting from useful directories
#'
#' * `path_temp()` starts the path with the session temporary directory
#' * `path_home()` starts the path with the users home directory
#'
#' @param ... Additional paths appended to the temporary directory by `path()`.
#' @export
#' @examples
#' path_home()
#' path_home("R")
#'
#' path_temp()
#' path_temp("does-not-exist")
path_home <- function(...) {
  path(path_expand("~"), ...)
}

#' @export
#' @rdname path_home
path_temp <- function(...) {
  path(tempdir(), ...)
}

#' Manipulate path extensions
#'
#' `path_ext()` returns the last extension (if any) for a path.
#' `path_ext_remove()` removes the last extension and returns the rest of the
#' path. `path_ext_set()` replaces the extension with a new extension. If there
#' is no existing extension the new extension is appended.
#' @template fs
#' @param ext,value The new file extension.
#' @export
#' @examples
#' path_ext("file.zip")
#' path_ext("file.tar.gz")
#'
#' path_ext_remove("file.tar.gz")
#'
#' # Only one level of extensions is removed
#' path_ext_set(path_ext_remove("file.tar.gz"), "zip")
path_ext <- function(path) {
  res <- captures(path, regexpr("(?<!^|[.])[.]([^.]+)$", path, perl = TRUE))[[1]]
  res[!is.na(path) & is.na(res)] <- ""
  path_tidy(res)
}

#' @rdname path_ext
#' @export
path_ext_remove <- function(path) {
  path_tidy(sub("(?<!^|[.])[.][^.]+$", "", path, perl = TRUE))
}

#' @rdname path_ext
#' @export
path_ext_set <- function(path, ext) {
  path_tidy(paste0(path_ext_remove(path), ".", ext))
}

#' @rdname path_ext
#' @export
`path_ext<-` <- function(path, value) {
  path_ext_set(path, value)
}
