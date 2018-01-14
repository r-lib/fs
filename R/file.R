#' Query file metadata
#'
#' Compared to `[file.info]` the full results of a `stat(2)` system call are
#' returned and some columns are returned as S3 classes to make manipulation
#' more natural. On systems which do not support all metadata (such as Windows)
#' default values are used.
#' @template fs
#' @return A data.frame with metadata for each file. Columns returned are as follows.
#'  \item{path}{The input path, as a [fs_path()] character vector.}
#'  \item{type}{The file type, as a factor of file types.}
#'  \item{size}{The file size, as a [fs_bytes()] numeric vector.}
#'  \item{permissions}{The file permissions, as a [fs_perms()] integer vector.}
#'  \item{modification_time}{The time of last data modification, as a [POSIXct] datetime.}
#'  \item{user}{The file owner name - as a character vector.}
#'  \item{group}{The file group name - as a character vector.}
#'  \item{device_id}{The file device id - as a numeric vector.}
#'  \item{hard_links}{The number of hard links to the file - as a numeric vector.}
#'  \item{special_device_id}{The special device id of the file - as a numeric vector.}
#'  \item{inode}{The inode of the file - as a numeric vector.}
#'  \item{block_size}{The optimal block for the file - as a numeric vector.}
#'  \item{blocks}{The number of blocks allocated for the file - as a numeric vector.}
#'  \item{flags}{The user defined flags for the file - as an integer vector.}
#'  \item{generation}{The generation number for the file - as a numeric vector.}
#'  \item{access_time}{The time of last access - as a [POSIXct] datetime.}
#'  \item{change_time}{The time of last file status change - as a [POSIXct] datetime.}
#'  \item{birth_time}{The time when the inode was created - as a [POSIXct] datetime.}
#' @seealso [dir_info()] to display file information for files in a given
#'   directory.
#' @examples
#' write.csv(mtcars, "mtcars.csv")
#' file_info("mtcars.csv")
#'
#' # Files in the working directory modified more than 20 days ago
#' files <- file_info(dir_ls())
#' files$path[difftime(Sys.time(), files$modification_time, units = "days") > 20]
#'
#' # Cleanup
#' file_delete("mtcars.csv")
#' @export
file_info <- function(path) {
  path <- path_expand(path)

  res <- stat_(path)

  res$path <- path_tidy(res$path)

  res$type <- factor(res$type, levels = file_types, labels = names(file_types))

  # TODO: convert to UTC times?
  res$access_time <- .POSIXct(res$access_time)
  res$modification_time <- .POSIXct(res$modification_time)
  res$change_time <- .POSIXct(res$change_time)
  res$birth_time <- .POSIXct(res$birth_time)

  important <- c("path", "type", "size", "permissions", "modification_time", "user", "group")
  res[c(important, setdiff(names(res), important))]
}

file_types <- c(
  "any" = -1,
  "block_device" = 0L,
  "character_device" = 1L,
  "directory" = 2L,
  "FIFO" = 3L,
  "symlink" = 4L,
  "file" = 5L,
  "socket" = 6L)

#' Change file permissions
#' @template fs
#' @param mode A character representation of the mode, in either hexidecimal or symbolic format.
#' @export
#' @examples
#' \dontshow{fs:::pkgdown_tmp("/tmp/filedd4670e2bc60")}
#' x <- file_create(file_temp(), "000")
#' file_chmod(x, "777")
#' file_info(x)$permissions
#'
#' file_chmod(x, "u-x")
#' file_info(x)$permissions
#'
#' file_chmod(x, "a-wrx")
#' file_info(x)$permissions
#'
#' file_chmod(x, "u+wr")
#' file_info(x)$permissions
file_chmod <- function(path, mode) {
  stopifnot(length(mode) == 1)
  mode <- as_fs_perms(mode, mode = file_info(path)$permissions)

  path <- path_expand(path)

  chmod_(path, mode)

  invisible(path_tidy(path))
}

#' Change owner or group of a file
#' @template fs
#' @param user_id The user id of the new owner, specified as a numeric ID or
#'   name. The R process must be privileged to change this.
#' @param group_id The group id of the new owner, specified as a numeric ID or
#'   name.
#' @export
file_chown <- function(path, user_id = NULL, group_id = NULL) {
  path <- path_expand(path)

  if (is.null(user_id)) {
    user_id <- -1
  }

  if (is.null(group_id)) {
    group_id <- -1
  }

  if (is.character(user_id)) {
    user_id <- getpwnam_(user_id)
  }

  if (is.character(group_id)) {
    user_id <- getgrnam_(user_id)
  }

  # TODO: use [getpwnam(3)](https://linux.die.net/man/3/getpwnam),
  # [getgrnam(3)](https://linux.die.net/man/3/getgrnam) to support specifying
  # uid / gid as names in addition to integers.
  chown_(path, user_id, group_id)

  invisible(path_tidy(path))
}

#' Open files or directories
#'
#' @template fs
#' @return The directories that were opened (invisibly).
#' @importFrom utils browseURL
#' @inheritParams utils::browseURL
#' @export
file_show <- function(path = ".", browser = getOption("browser")) {
  for (p in path) {
    browseURL(p)
  }

  invisible(path_tidy(path))
}

file_watch <- function(path, fun) {
  watch_(path, fun)
}
