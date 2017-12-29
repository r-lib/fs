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

  new_fs_filename(path.expand(path))
}

#' Tidy paths
#'
#' untidy paths are all different, tidy paths are all the same.
#' Tidy paths always expand `~`, use `/` to delimit directories, never have
#' multiple `/` or trailing `/` and have colourised output based on the file
#' type.
#'
#' @return A fs_filename object
#' @template fs
#' @return a 
#' @export
path_tidy <- function(path) {
  path <- path_expand(path)

  # convert `\\` to `/`
  path <- gsub("\\\\", "/", path)

  # convert multiple // to single /
  path <- gsub("//+", "/", path)

  # Remove trailing / from paths
  path <- sub("/$", "", path)

  new_fs_filename(path)
}

#' Provide the path to the users home directory
#' @export
path_home <- function() {
  path_expand("~")
}

#' Split a path into components
#'
#' @template fs
#' @return A list of separated paths
#' @export
path_split <- function(path) {
  path <- path_expand(path)

  # Split on all but leading /
  strsplit(path, "(?<=.)/+", perl = TRUE)
}

#' Path to sessions temporary directory
#'
#' Analogous to [base::tempdir()].
#' @export
path_temp <- function() {
  path_tidy(tempdir())
}
