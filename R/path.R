#' Path computations
#'
#' All functions apart from [path_expand()] and [path_real()] are purely
#' path computations, so the files in question do not need to exist on the
#' filesystem.
#' @template fs
#' @name path_math
#' @return The new path as a character vector. For [path_split()], a list of
#'   character vectors of path components is returned instead.
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' # Expand a path
#' path_expand("~/bin")
#'
#' dir_create("a")
#' file_create("a/b")
#' link_create(path_abs("a"), "c")
#'
#' # Realize the path
#' path_real("c/b")
#'
#' # Split a path
#' parts <- path_split("a/b")
#' parts
#'
#' # Join it together
#' path_join(parts)
#'
#' # Find the absolute path
#' path_abs("..")
#'
#' # Normalize a path
#' path_norm("a/../b\\c/.")
#'
#' # Compute a relative path
#' path_rel("/foo/abc", "/foo/bar/baz")
#'
#' # Find the common path between multiple paths
#' path_common(c("/foo/bar/baz", "/foo/bar/abc", "/foo/xyz/123"))
#'
#' # Cleanup
#' dir_delete("a")
#' link_delete("c")
#' \dontshow{setwd(.old_wd)}
NULL

#' Construct path to a file or directory
#'
#' @template fs
#' @param ... character vectors, if any values are NA, the result will also be
#'   NA.
#' @param ext An optional extension to append to the generated path.
#' @export
#' @seealso [path_home()], [path_package()] for functions to construct paths
#'   relative to the home and package directories respectively.
#' @examples
#' path("foo", "bar", "baz", ext = "zip")
#'
#' path("foo", letters[1:3], ext = "txt")
path <- function(..., ext = "") {
  path_tidy(path_(lapply(list(...), function(x) enc2utf8(as.character(x))), ext))
}

#' @describeIn path_math returns the canonical path, eliminating any symbolic
#' links.
#' @export
path_real <- function(path) {
  path <- enc2utf8(path)
  old <- path_expand(path)

  is_missing <- is.na(path)
  old[!is_missing] <- realize_(old[!is_missing])

  path_tidy(old)
}


#' Tidy paths
#'
#' untidy paths are all different, tidy paths are all the same.
#' Tidy paths always use `/` to delimit directories, never have
#' multiple `/` or trailing `/` and have colourised output based on the file
#' type.
#'
#' @return A fs_path object
#' @template fs
#' @export
path_tidy <- function(path) {
  path <- as.character(path)
  new_fs_path(tidy_(path))
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

#' @describeIn path_math joins parts together. The inverse of [path_split()].
#' See [path()] to concatenate vectorized strings into a path.
#' @param parts A list of character vectors, corresponding to split paths.
#' @export
path_join <- function(parts) {
  if (length(parts) == 0) {
    return(path_tidy(""))
  }
  if (is.character(parts)) {
    return(path_tidy(path_(enc2utf8(parts), "")))
  }
  path_tidy(vapply(parts, path_join, character(1)))
}

#' @describeIn path_math returns a normalized, absolute version of a path.
#' @export
path_abs <- function(path, start = ".") {
  if (!is_absolute_path(start)) {
    start <- path_norm(path(getwd(), start))
  }
  is_abs <- is_absolute_path(path)
  path[is_abs] <- path_norm(path[is_abs])
  path[!is_abs] <- path_norm(path(start, path[!is_abs]))
  path_tidy(path)
}


#' @describeIn path_math collapses redundant separators and
#' up-level references, so `A//B`, `A/B`, `A/.B` and `A/foo/../B` all become
#' `A/B`. If one of the paths is a symbolic link, this may change the meaning
#' of the path, in this case one should use [path_real()] prior to calling
#' [path_norm()].
#' @export
path_norm <- function(path) {
  non_missing <- !is.na(path)

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
  parts[non_missing] <- vapply(parts[non_missing], path_norm_one, character(1))
  path_tidy(parts)
}

#' @describeIn path_math computes the path relative to the `start` path,
#'   which can be either a absolute or relative path.
#' @export
#' @param start A starting directory to compute the path to.
# This implementation is partially derived from
# https://github.com/python/cpython/blob/9c99fd163d5ca9bcc0b7ddd0d1e3b8717a63237c/Lib/posixpath.py#L446
path_rel <- function(path, start = ".") {
  start <- path_abs(path_expand(start))
  path <- path_abs(path_expand(path))

  path_rel_one <- function(p) {
    common <- path_common(c(start, p))
    starts <- path_split(start)[[1]]
    paths <- path_split(p)[[1]]

    i <- length(path_split(common)[[1]])
    double_dot_part <- rep("..", (length(starts) - i))
    if (i + 1 <= length(paths)) {
      path_part <- paths[seq(i + 1, length(paths))]
    } else {
      path_part <- character()
    }
    rels <- c(double_dot_part, path_part)
    if (length(rels) == 0) {
      return(path_tidy("."))
    }

    path_join(rels)
  }
  if (is.na(start)) {
    return(path_tidy(NA_character_))
  }

  is_missing <- is.na(path)

  path[!is_missing] <- vapply(path[!is_missing], path_rel_one, character(1))

  path_tidy(path)
}

#' Finding the User Home Directory
#'
#' * `path_expand()` performs tilde expansion on a path, replacing instances of
#' `~` or `~user` with the user's home directory.
#' * `path_home()` constructs a path within the expanded users home directory,
#'   calling it with _no_ arguments can be useful to verify what fs considers the
#'   home directory.
#' * `path_expand_r()` and `path_home_r()` are equivalents which always use R's
#'   definition of the home directory.
#' @details
#' `path_expand()` Differs from [path.expand()] in the interpretation of the
#' home directory of Windows. In particular `path_expand()` uses the path set
#' in `USERPROFILE`, if unset then `HOMEDRIVE`/`HOMEPATH` is used.
#'
#' In contrast [path.expand()] first checks for `R_USER` then `HOME`, which in the default
#' configuration of R on Windows are both set to the users document directory, e.g.
#' `C:\\Users\\username\\Documents`. `path.expand()` also does not support
#' `~otheruser` syntax on Windows, whereas `path_expand()` does support this
#' syntax on all systems.
#'
#' This definition makes fs more consistent with the definition of home directory used
#' on Windows in other languages, such as
#' [python](https://docs.python.org/3/library/os.path.html#os.path.expanduser)
#' and [rust](https://doc.rust-lang.org/std/env/fn.home_dir.html#windows).
#' This is also more compatible with external tools such as git and ssh, both of
#' which put user-level files in `USERPROFILE` by default. It also allows you
#' to write portable paths, such as `~/Desktop` that points to the Desktop
#' location on Windows, MacOS and (most) Linux systems.
#'
#' Users can set the `R_FS_HOME` environment variable to override the
#' definitions on any platform.
#' @seealso [R for Windows FAQ - 2.14](https://cran.r-project.org/bin/windows/base/rw-FAQ.html#What-are-HOME-and-working-directories_003f)
#' for behavior of [base::path.expand()].
#' @param ... Additional paths appended to the home directory by `path()`.
#' @inheritParams path_math
#' @export
#' @examples
#' # You can use `path_home()` without arguments to see what is being used as
#' # the home diretory.
#' path_home()
#' path_home("R")
#'
#' # This will likely differ from the above on Windows
#' path_home_r()
path_expand <- function(path) {
  path <- enc2utf8(path)

  # We use the windows implementation if R_FS_HOME is set or if on windows
  path_tidy(expand_(path, Sys.getenv("R_FS_HOME") != "" || is_windows()))
}

#' @rdname path_expand
#' @export
path_expand_r <- function(path) {
  path <- enc2utf8(path)

  # Unconditionally use R_ExpandFileName
  path_tidy(expand_(path, FALSE))
}

#' @rdname path_expand
#' @export
path_home <- function(...) {
  path(path_expand("~/"), ...)
}

#' @rdname path_expand
#' @export
path_home_r <- function(...) {
  path(path_expand_r("~/"), ...)
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
  is_missing <- is.na(path)
  path[!is_missing] <- basename(path[!is_missing])
  path_tidy(path)
}

#' @rdname path_file
#' @export
path_dir <- function(path) {
  is_missing <- is.na(path)
  path[!is_missing] <- dirname(path[!is_missing])
  path_tidy(path)
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

#' @describeIn path_math finds the common parts of two (or more) paths.
#' @export
path_common <- function(path) {

  is_missing <- is.na(path)

  if (any(is_missing)) {
    return(path_tidy(NA))
  }

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

#' Filter paths
#'
#' @template fs
#' @param glob A wildcard aka globbing pattern (e.g. `*.csv`) passed on to [grep()] to filter paths.
#' @param regexp A regular expression (e.g. `[.]csv$`) passed on to [grep()] to filter paths.
#' @param invert If `TRUE` return files which do _not_ match
#' @param ... Additional arguments passed to [grep].
#' @export
#' @examples
#' path_filter(c("foo", "boo", "bar"), glob = "*oo")
#' path_filter(c("foo", "boo", "bar"), glob = "*oo", invert = TRUE)
#'
#' path_filter(c("foo", "boo", "bar"), regexp = "b.r")
path_filter <- function(path, glob = NULL, regexp = NULL, invert = FALSE, ...) {
  if (!is.null(glob)) {
    if (!is.null(regexp)) {
      stop("`glob` and `regexp` cannot both be set.", call. = FALSE)
    }
    regexp <- utils::glob2rx(glob)
  }
  if (!is.null(regexp)) {
    path <- grep(x = path, pattern = regexp, value = TRUE, invert = isTRUE(invert), ...)
  }
  setNames(path_tidy(path), path)
}
