#' Construct path to a file or directory
#'
#' @template fs
#' @param ... character vectors, if any values are NA, the result will also be
#'   NA.
#' @param ext An optional extension to append to the generated path.
#' @export
#' @seealso [base::file.path()]
path <- function(..., ext = "") {
  path_tidy(path_(lapply(list(...), as.character), ext))
}

#' Return the canonicalized absolute pathname
#'
#' This is functionally equivalent to [base::normalizePath()].
#'
#' @template fs
#' @return `[character(1)]` the fully resolved path.
#' @export
path_realize <- function(path) {
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
  # split keep unc paths together, but keep root paths as first part.
  # //foo => '//foo' 'bar'
  # /foo/bar => '/' 'foo' 'bar'
  strsplit(path, "^(?=/)(?!//)|(?<!^)(?<!^/)/", perl = TRUE)
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

#' Manipulate file paths
#'
#' `path_file()` returns the filename portion of the path, `path_dir()` returns
#' the directory portion. `path_ext()` returns the last extension (if any) for a path.
#' `path_ext_remove()` removes the last extension and returns the rest of the
#' path. `path_ext_set()` replaces the extension with a new extension. If there
#' is no existing extension the new extension is appended.
#' @template fs
#' @param ext,value The new file extension.
#' @seealso [basename()], [dirname()]
#' @export
#' @examples
#' path_file("dir/file.zip")
#'
#' path_dir("dir/file.zip")
#'
#' path_ext("dir/file.zip")
#'
#' path_ext("file.tar.gz")
#'
#' path_ext_remove("file.tar.gz")
#'
#' # Only one level of extension is removed
#' path_ext_set(path_ext_remove("file.tar.gz"), "zip")
#' @export
path_file <- function(path) {
  path_tidy(basename(path))
}

#' @rdname path_file
#' @export
path_dir <- function(path) {
  path_tidy(dirname(path))
}

#' @rdname path_file
#' @export
path_ext <- function(path) {
  res <- captures(path, regexpr("(?<!^|[.])[.]([^.]+)$", path, perl = TRUE))[[1]]
  res[!is.na(path) & is.na(res)] <- ""
  path_tidy(res)
}

#' @rdname path_file
#' @export
path_ext_remove <- function(path) {
  path_tidy(sub("(?<!^|[.])[.][^.]+$", "", path, perl = TRUE))
}

#' @rdname path_file
#' @export
path_ext_set <- function(path, ext) {
  path[!is.na(path)] <- paste0(path_ext_remove(path[!is.na(path)]), ".", ext)
  path_tidy(path)
}

#' @rdname path_file
#' @export
`path_ext<-` <- function(path, value) {
  path_ext_set(path, value)
}


#' Find the common parts of two (or more) paths
#'
#' The input paths must be either all relative or all absolute.
#' @template fs
#' @export
path_common <- function(path) {
  path <- sort(path_tidy(path))
  is_abs <- is_absolute_path(path)

  # We must either have all absolute paths, or all relative paths.
  if (!(all(is_abs) || all(!is_abs))) {
    stop("Can't mix absolute and relative paths", call. = FALSE)
  }

  # remove . entries from the split paths
  path <- lapply(path_split(path), function(x) x[x != "."])

  s1 <- path[[1]]
  s2 <- path[[length(path)]]
  common <- s1
  for (i in seq_along(s1)) {
    if (s1[[i]] != s2[[i]]) {
      if (i == 1) {
        common <- ""
      } else {
        common <- s1[seq(1, i - 1)]
      }
      break;
    }
  }

  if (isTRUE(is_abs[[1]])) {
    return(path_tidy(paste0(common[[1]], paste0(common[-1], collapse = "/"))))
  }
  return(path_tidy(paste0(common, collapse = "/")))
}
