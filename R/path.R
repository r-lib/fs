#' Return the canonicalized absolute pathname
#'
#' This is functionally equivalent to [base::normalizePath()].
#'
#' @template fs
#' @return `[character(1)]` the fully resolved path.
#' @aliases dir_realpath
#' @export
path_norm <- function(path) {
  path <- enc2utf8(path)

  realpath_(path_expand(path))
}


#' Perform tilde expansion of a pathname
#'
#' equivalent to [base::path.expand]
#' @export
# TODO: so far it looks like libuv does not provide a cross platform version of
# this https://github.com/libuv/libuv/issues/11
path_expand <- function(path) {
  path <- enc2utf8(path)

  enc2utf8(path.expand(path))
}

#' Provide the path to the users home directory
#' @template fs
#' @export
path_home <- function() {
  enc2utf8(path.expand("~"))
}

#' Split a path into components
#' @template fs
#' @export
path_split <- function(path) {
  path <- enc2utf8(path)

  path <- path_norm(path)

  strsplit(path_norm(path), "/+")[[1]]
}
