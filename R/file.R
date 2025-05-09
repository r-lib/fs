#' Query file metadata
#'
#' Compared to [file.info()] the full results of a `stat(2)` system call are
#' returned and some columns are returned as S3 classes to make manipulation
#' more natural. On systems which do not support all metadata (such as Windows)
#' default values are used.
#' @template fs
#' @param follow If `TRUE`, symbolic links will be followed (recursively) and
#'   the results will be that of the final file rather than the link.
#' @inheritParams dir_ls
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
#' \dontshow{.old_wd <- setwd(tempdir())}
#' write.csv(mtcars, "mtcars.csv")
#' file_info("mtcars.csv")
#'
#' # Files in the working directory modified more than 20 days ago
#' files <- file_info(dir_ls())
#' files$path[difftime(Sys.time(), files$modification_time, units = "days") > 20]
#'
#' # Cleanup
#' file_delete("mtcars.csv")
#' \dontshow{setwd(.old_wd)}
#' @export
file_info <- function(path, fail = TRUE, follow = FALSE) {
  old <- path_expand(path)

  res <- .Call(fs_stat_, old, fail)

  res$path <- path_tidy(path)

  res$type <- factor(res$type, levels = file_types, labels = names(file_types))

  # TODO: convert to UTC times?
  res$access_time <- .POSIXct(res$access_time)
  res$modification_time <- .POSIXct(res$modification_time)
  res$change_time <- .POSIXct(res$change_time)
  res$birth_time <- .POSIXct(res$birth_time)

  important <- c(
    "path",
    "type",
    "size",
    "permissions",
    "modification_time",
    "user",
    "group"
  )
  res <- res[c(important, setdiff(names(res), important))]

  is_symlink <- !is.na(res$type) & res$type == "symlink"
  while (follow && any(is_symlink)) {
    lpath <- link_path(path[is_symlink])
    lpath <- ifelse(
      is_absolute_path(lpath),
      lpath,
      path(path_dir(path[is_symlink]), lpath)
    )
    res[is_symlink, ] <- file_info(lpath, fail = fail, follow = FALSE)
    is_symlink <- !is.na(res$type) & res$type == "symlink"
  }

  res
  as_tibble(res)
}

#' @export
#' @rdname file_info
file_size <- function(path, fail = TRUE) {
  res <- file_info(path, fail)

  stats::setNames(res$size, path)
}

file_types <- c(
  "any" = -1,
  "block_device" = 0L,
  "character_device" = 1L,
  "directory" = 2L,
  "FIFO" = 3L,
  "symlink" = 4L,
  "file" = 5L,
  "socket" = 6L
)

#' Change file permissions
#' @template fs
#' @param mode A character representation of the mode, in either hexidecimal or symbolic format.
#' @details **Cross-compatibility warning:** File permissions differ on Windows
#'   from POSIX systems. Windows does not use an executable bit, so attempting
#'   to change this will have no effect. Windows also does not have user
#'   groups, so only the user permissions (`u`) are relevant.
#' @export
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' file_create("foo", mode = "000")
#' file_chmod("foo", "777")
#' file_info("foo")$permissions
#'
#' file_chmod("foo", "u-x")
#' file_info("foo")$permissions
#'
#' file_chmod("foo", "a-wrx")
#' file_info("foo")$permissions
#'
#' file_chmod("foo", "u+wr")
#' file_info("foo")$permissions
#'
#' # It is also vectorized
#' files <- c("foo", file_create("bar", mode = "000"))
#' file_chmod(files, "a+rwx")
#' file_info(files)$permissions
#'
#' file_chmod(files, c("644", "600"))
#' file_info(files)$permissions
#' \dontshow{setwd(.old_wd)}
file_chmod <- function(path, mode) {
  assert_no_missing(path)
  mode <- as_fs_perms(mode, mode = file_info(path)$permissions)

  old <- path_expand(path)

  .Call(fs_chmod_, old, as.integer(mode))

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
  assert_no_missing(path)

  old <- path_expand(path)

  if (is.null(user_id)) {
    user_id <- -1
  }

  if (is.null(group_id)) {
    group_id <- -1
  }

  if (is.character(user_id)) {
    user_id <- .Call(fs_getpwnam_, user_id)
  }

  if (is.character(group_id)) {
    group_id <- .Call(fs_getgrnam_, group_id)
  }

  .Call(fs_chown_, old, as.integer(user_id), as.integer(group_id))

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
  assert_no_missing(path)

  old <- path_expand(path)

  for (p in path) {
    browseURL(p, browser = browser)
  }

  invisible(path_tidy(path))
}


#' Move or rename files
#'
#' Compared to [file.rename] `file_move()` always fails if it is unable to move
#' a file, rather than signaling a Warning and returning an error code.
#' @template fs
#' @param new_path New file path. If `new_path` is existing directory, the file
#'   will be moved into that directory; otherwise it will be moved/renamed to
#'   the full path.
#'
#'   Should either be the same length as `path`, or a single directory.
#' @return The new path (invisibly).
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' file_create("foo")
#' file_move("foo", "bar")
#' file_exists(c("foo", "bar"))
#' file_delete("bar")
#' \dontshow{setwd(.old_wd)}
#' @export
file_move <- function(path, new_path) {
  assert_no_missing(path)
  assert_no_missing(new_path)

  old <- path_expand(path)
  new <- path_expand(new_path)

  is_directory <- file_exists(new) & is_dir(new)

  if (length(new) == 1 && is_directory[[1]]) {
    new <- rep(new, length(path))
  }
  assert(
    "Length of `path` must equal length of `new_path`",
    length(old) == length(new)
  )

  new[is_directory] <- path(new[is_directory], basename(old))

  .Call(fs_move_, old, new)

  invisible(path_tidy(new))
}

#' Change file access and modification times
#'
#' Like the touch POSIX utility this will create the file if it does not
#' exist.
#'
#' @template fs
#'
#' @param access_time,modification_time The times to set, inputs will be
#'   coerced to [POSIXct] objects.
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' file_touch("foo", "2018-01-01")
#' file_info("foo")[c("access_time", "modification_time", "change_time", "birth_time")]
#' \dontshow{setwd(.old_wd)}
#' @export
file_touch <- function(
  path,
  access_time = Sys.time(),
  modification_time = access_time
) {
  assert_no_missing(path)

  access_time <- as.POSIXct(access_time)
  modification_time <- as.POSIXct(modification_time)

  path <- path_expand(path)

  .Call(fs_create_, path, 420L)
  .Call(fs_touch_, path, access_time, modification_time)

  invisible(path_tidy(path))
}
