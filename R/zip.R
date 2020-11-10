#' List zip contents
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
      x <- cbind(x, zip = i)
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
#' @param path A character vector of zip archives.
#' @param files A character vector of paths to be extracted: the default is to
#'   extract all files.
#' @param dir The directory to extract files to (the equivalent of `unzip -d`).
#'   It will be created if necessary.
#' @param overwrite If `TRUE` (default), overwrite existing files (the
#'   equivalent of `unzip -o`), otherwise ignore such files (the equivalent of
#'   `unzip -n`).
#' @param junkpaths If `TRUE`, use only the basename of the stored path when
#'   extracting. The equivalent of `unzip -j`.
#' @param method The method to be used. An alternative is to use
#'   `getOption("unzip")`, which on a Unix-alike may be set to the path to a
#'   unzip program.
#' @return The path to the extracted files (invisibly).
#' @export
zip_move <- function(zip, dir = NULL, files = NULL, overwrite = TRUE,
                     junkpaths = FALSE, method = "internal") {
  if (is.null(dir) | length(dir) > 1) {
    stop("one destination dir must be provided")
  }
  zip <- path_real(zip)
  dir <- dir_create(dir)
  z <- character()
  for (i in seq_along(zip)) {
    x <- utils::unzip(
      zipfile = zip[i], files = files, overwrite = overwrite,
      junkpaths = junkpaths, exdir = dir, unzip = method,
    )
    z <- append(z, x)
  }
  invisible(as_fs_path(z))
}

#' Create zip archive
#'
#' @param path A character vector of files to archive.
#' @param zip The path of the zip file to create. If none is supplied, and only
#'   one path is supplied, an archive with that name will be created.
#' @param quiet If `TRUE`, suppress deflating messages. The equivalent of
#'   `zip -q`.
#' @param junkpaths If `TRUE`, use only the basename of the path when
#'   creating the archive. The equivalent of `zip -j`.
#' @param method A character string specifying the external command to be used.
#' @return The path to the created archive (invisibly).
#' @export
zip_create <- function(path, zip = NULL, quiet = TRUE, junkpaths = FALSE,
                       method = Sys.getenv("R_ZIPCMD", "zip")) {
  path <- path_real(path)
  if (is.null(zip) && length(path) == 1) {
    zip <- path_ext_set(path, "zip")
  } else {
    zip <- path_expand(zip)
  }
  x <- ""
  if (junkpaths) {
    x <- c(x, "-j")
  }
  if (quiet) {
    x <- c(x, "-q")
  }
  utils::zip(zipfile = zip, files = path, zip = method, extra = x)
  invisible(zip)
}
