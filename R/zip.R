#' List zip contents
#'
#' @description
#' Equivalent to the `unzip -l` command. It returns the compressed files within
#' the given archives, much like [dir_ls()] returns files in a directory. If
#' more than one archive is provided, files are identified by their source.
#'
#' @param path A character vector of zip archives.
#' @param method The method to be used. An alternative is to use
#'   `getOption("unzip")`, which on a Unix-alike may be set to the path to a
#'   unzip program.
#' @examples
#' # List two files from zip
#' irs <- file_temp(ext = "csv")
#' write.csv(iris, irs)
#' mtc <- file_temp(ext = "csv")
#' write.csv(mtcars, mtc)
#' zip <- path_temp("two.zip")
#' zip_create(c(irs, mtc), zip)
#' zip_ls(zip)
#' @export
zip_ls <- function(path, method = "internal") {
  path <- path_real(path)
  z <- mapply(
    FUN = utils::unzip, zipfile = path,
    SIMPLIFY = FALSE, USE.NAMES = TRUE,
    MoreArgs = list(list = TRUE)
  )
  z <- do.call(what = "rbind", args = z)
  names(z)[1:3] <- c("path", "size", "date")
  z$path <- as_fs_path(z$path)
  z$size <- as_fs_bytes(z$size)
  as_tibble(z)
}

#' Extract zip contents
#'
#' @description
#' Decompress the contents of a zip archive and extract them to a single
#' directory so they can be read. Compared to [utils::unzip()], a directory
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
#' @examples
#' # Extract two files from zip
#' tmp <- path_temp("iris.csv")
#' write.csv(iris, tmp)
#' zip <- zip_create(tmp, junk = TRUE)
#' out <- zip_move(zip, dir = path_temp("out"))
#' file_size(c(tmp, zip, out))
#' @export
zip_move <- function(path, dir = NULL, files = NULL, overwrite = TRUE,
                     junk = FALSE, method = "internal") {
  if (is.null(dir) | length(dir) > 1) {
    stop("one destination directory must be specified")
  }
  path <- path_real(path)
  dir <- dir_create(dir)
  z <- mapply(
    FUN = utils::unzip, zipfile = path,
    SIMPLIFY = TRUE, USE.NAMES = TRUE,
    MoreArgs = list(
      files = files, overwrite = overwrite,
      junkpaths = junk, exdir = dir, unzip = method
    )
  )
  invisible(as_fs_path(z))
}

#' Create zip archive
#'
#' @description
#' A wrapper for an external `zip` command to create zip archives. Unlike
#' [utils::zip()], filepaths can be passed into the first argument with `%>%`.
#'
#' @param path A character vector of files to archive.
#' @param zip The path of the zip file to create. If none is supplied, and only
#'   one path is, an archive with that [basename()] will be created in the same
#'   directory.
#' @param quiet If `TRUE`, suppress deflating messages (the equivalent of
#'   `zip -q`).
#' @param junk If `TRUE`, use only the basename of the path when creating the
#'   archive (the equivalent of `zip -j`).
#' @param extra An optional character vector passed to [system()] as arguments
#'   of the external `zip` command (e.g., `-x` followed by paths to exclude).
#' @param method A character string specifying the external command to be used.
#' @return The path of the created archive (invisibly).
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' # Zip a file to same basename
#' tmp <- path_temp("iris.csv")
#' write.csv(iris, tmp)
#' (zip <- zip_create(tmp))
#' file_size(c(tmp, zip))
#' \dontshow{setwd(.old_wd)}
#' @export
zip_create <- function(path, zip = NULL, quiet = TRUE, junk = FALSE,
                       extra = "", method = Sys.getenv("R_ZIPCMD", "zip")) {
  path <- path_real(path)
  if (is.null(zip) && length(path) == 1) {
    zip <- path_ext_set(path, "zip")
  } else {
    zip <- path_expand(zip)
  }
  x <- c("-j", "-q")[c(junk, quiet)]
  utils::zip(zipfile = zip, files = path, zip = method, extra = c(extra, x))
  invisible(zip)
}
