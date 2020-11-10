#' List zip contents
#'
#' Equivalent to the `unzip -l` command. It returns the compressed files within
#' the given archives, much like [dir_ls()] returns files in a directory. If
#' more than one archive is provided, files are identified by their source.
#'
#' @param path A character vector of zip archives.
#' @param method The method to be used. An alternative is to use
#'   `getOption("unzip")`, which on a Unix-alike may be set to the path to a
#'   unzip program.
#' @export
zip_ls <- function(path, method = "internal") {
  path <- path_real(path)
  z <- data.frame()
  for (i in seq_along(path)) {
    x <- utils::unzip(path[i], list = TRUE, unzip = method)
    if (length(path) > 1) {
      x <- cbind(x, source = i)
    }
    z <- rbind(z, x)
  }
  names(z)[1:3] <- c("path", "size", "date")
  z$path <- as_fs_path(z$path)
  z$size <- as_fs_bytes(z$size)
  as_tibble(z)
}

#' Extract zip contents
#'
#' Decompress the contents of a zip archive and extract them to a single
#' directory so they can be read. Compared to [untils::unzip()], a directory
#' _must_ be provided in the `dir` directory; files are not automatically
#' extracted to the current working directory. New file paths are returned
#' invisibly.
#'
#' @param path A character vector of zip archives.
#' @param dir The directory to extract files to (the equivalent of `unzip -d`).
#'   It will be created if necessary with [dir_create()].
#' @param files A character vector of paths to be extracted: the default is to
#'   extract all files. Use [zip_ls()] to list contents without extracting.
#' @param overwrite If `TRUE` (default), overwrite existing files (the
#'   equivalent of `unzip -o`), otherwise ignore such files (the equivalent of
#'   `unzip -n`).
#' @param junk If `FALSE` (default), preserve the directories of compressed
#'   files. If `TRUE`, use only the basename of the stored path when extracting
#'   (the equivalent of `unzip -j`).
#' @param method The method to be used. An alternative is to use
#'   `getOption("unzip")`, which on a Unix-alike may be set to the path to a
#'   unzip program.
#' @return The path to the extracted files (invisibly).
#' @export
zip_move <- function(path, dir = NULL, files = NULL, overwrite = TRUE,
                     junk = FALSE, method = "internal") {
  if (is.null(dir) | length(dir) > 1) {
    stop("one destination directory must be specified")
  }
  path <- path_real(path)
  dir <- dir_create(dir)
  z <- character()
  for (i in seq_along(path)) {
    x <- utils::unzip(
      zipfile = path[i], files = files, overwrite = overwrite,
      junkpaths = junk, exdir = dir, unzip = method,
    )
    z <- append(z, x)
  }
  invisible(as_fs_path(z))
}

#' Create zip archive
#'
#' A wrapper for an external `zip` command to create zip archives. Unlike
#' [utils::zip()], filepaths can be passed into the first argument with `%>%`.
#'
#' @param path A character vector of files to archive.
#' @param zip The path of the zip file to create. If none is supplied, and only
#'   one path is supplied, an archive with that name will be created in the
#'   same directory as the source file.
#' @param quiet If `TRUE`, suppress deflating messages (the equivalent of
#'   `zip -q`).
#' @param junk If `TRUE`, use only the basename of the path when creating the
#'   archive (the equivalent of `zip -j`).
#' @param method A character string specifying the external command to be used.
#' @return The path to the created archive (invisibly).
#' @export
zip_create <- function(path, zip = NULL, quiet = TRUE, junk = FALSE,
                       method = Sys.getenv("R_ZIPCMD", "zip")) {
  path <- path_real(path)
  if (is.null(zip) && length(path) == 1) {
    zip <- path_ext_set(path, "zip")
  } else {
    zip <- path_expand(zip)
  }
  x <- ""
  if (junk) {
    x <- c(x, "-j")
  }
  if (quiet) {
    x <- c(x, "-q")
  }
  utils::zip(zipfile = zip, files = path, zip = method, extra = x)
  invisible(zip)
}
