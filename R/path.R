#' Path computations
#'
#' @template fs
#' @name path_math
NULL

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

#' @describeIn path_math returns the canonical path, eliminating any symbolic
#' links.
#' @export
path_realize <- function(path) {
  path <- enc2utf8(path)

  path_tidy(realize_(path_expand(path)))
}


#' @describeIn path_math performs tilde expansion on a path, replacing instances of
#' `~` or `~user` with the user's home directory.
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


#' @describeIn path_math splits paths into parts.
#' @export
# TODO: examples
path_split <- function(path) {
  path <- path_tidy(path)

  # Split drive / UNC parts
  # split keep unc paths together, but keep root paths as first part.
  # //foo => '//foo' 'bar'
  # /foo/bar => '/' 'foo' 'bar'
  strsplit(path, "^(?=/)(?!//)|(?<!^)(?<!^/)/", perl = TRUE)
}

#' @describeIn path_math joins parts together.
#' @param parts A list of character vectors, corresponding to split paths.
#' @export
path_join <- function(parts) {
  if (length(parts) == 0) {
    return(path_tidy(""))
  }
  path_tidy(path_(parts, ""))
}

#' @describeIn path_math returns a normalized, absolute version of a path.
#' @export
path_absolute <- function(path) {
  is_abs <- is_absolute_path(path)
  path[is_abs] <- path_norm(path[is_abs])
  cwd <- getwd()
  path[!is_abs] <- path_norm(path(cwd, path[!is_abs]))
  path
}

#' @describeIn path_math collapses redundant separators and
#' up-level references, so `A//B`, `A/B`, `A/.B` and `A/foo/../B` all become
#' `A/B`. If one of the paths is a symbolic link, this may change the meaning
#' of the path, in this case one can use `path_realize()` beforehand to follow
#' the symlink.
#' @export
path_norm <- function(path) {
  parts <- path_split(path)
  path_norm_one <- function(p) {
    p <- p[p != "."]
    double_dots <- p == ".."
    if (any(double_dots)) {
      res <- character(length(p))
      size <- 0
      is_abs <- is_absolute_path(p[[1]])
      for (i in seq_along(p)) {
        if (p[[i]] != ".." || (! is_abs && size == 0) || (size > 0 && res[[size]] == "..")) {
          res[[size <- size + 1]] <- p[[i]]
        } else if (size > 0) {
          size <- size - 1
        }
      }
      res <- res[seq(1, size)]
      if (is_abs && res[[1]] != p[[1]]) {
        res <- c(p[[1]], res)
      }
      p <- res
    }
    if (length(p) == 0) {
      return(path_tidy("."))
    }
    path_join(p)
  }
  path_tidy(vapply(parts, path_norm_one, character(1)))
}

#' @export
#' @rdname path_math
#' @param start A starting directory to compute relative path to.
# This implementation is partially derived from
# https://github.com/python/cpython/blob/9c99fd163d5ca9bcc0b7ddd0d1e3b8717a63237c/Lib/posixpath.py#L446
path_relative <- function(path, start = ".") {
  start <- path_absolute(start)
  path <- path_absolute(path)

  path_relative_one <- function(p) {
    common <- path_common(c(start, p))
    start_lst <- path_split(start)[[1]]
    path_lst <- path_split(p)[[1]]

    i <- length(path_split(common)[[1]])
    double_dot_part <- rep("..", (length(start_lst) - i))
    if (i + 1 <= length(path_lst)) {
      path_part <- path_lst[seq(i + 1, length(path_lst))]
    } else {
      path_part <- list()
    }
    rel_lst = c(double_dot_part, path_part)
    if (length(rel_lst) == 0) {
      return(path_tidy("."))
    }

    path_join(rel_lst)
  }
  path_tidy(vapply(path, path_relative_one, character(1)))
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

#' @describeIn path_math Find the common parts of two (or more) paths
#' @export
path_common <- function(path) {
  is_abs <- is_absolute_path(path)

  # We must either have all absolute paths, or all relative paths.
  if (!(all(is_abs) || all(!is_abs))) {
    stop("Can't mix absolute and relative paths", call. = FALSE)
  }

  path <- path_norm(path)
  path <- sort(path)

  # remove . entries from the split paths
  parts <- lapply(path_split(path), function(x) x[x != "."])
  s1 <- parts[[1]]
  s2 <- parts[[length(parts)]]
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
  path_join(common)
}
