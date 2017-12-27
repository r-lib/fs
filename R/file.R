#' Query file metadata
#' @template fs
#' @return A data.frame with metadata for each file
#' @export
file_info <- function(path) {
  path <- path_expand(path)

  res <- stat_(path)

  res$path <- new_fs_filename(res$path, res$permissions)

  res$type <- factor(res$type, levels = file_types, labels = names(file_types))

  # TODO: convert to UTC times?
  res$access_time <- .POSIXct(res$access_time)
  res$modification_time <- .POSIXct(res$modification_time)
  res$creation_time <- .POSIXct(res$creation_time)
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
#' x <- file_create(tempfile(), "000")
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
  path <- path_expand(path)

  chmod_(path, mode)

  invisible(path)
}

#' Delete a file
#' @template fs
#' @examples
#' x <- file_create(tempfile())
#' file_exists(x)
#' file_delete(x)
#' file_exists(x)
#' @export
file_delete <- function(path) {
  path <- path_expand(path)
  unlink_(path)

  invisible(path)
}

#' Copy a file
#' @param new_path Character vector of paths to the new files.
#' @param overwrite Overwrite files if they exist. If this is `FALSE` and a
#'   file exists and error will be thrown.
#' @template fs
#' @examples
#' file_create("foo")
#' file_copy("foo", "bar")
#' try(file_copy("foo", "bar"))
#' file_copy("foo", "bar", overwrite = TRUE)
#' file_delete(c("foo", "bar"))
#' @export
file_copy <- function(path, new_path, overwrite = FALSE) {
  path <- path_expand(path)
  new_path <- path_expand(new_path)
  copyfile_(path, new_path, isTRUE(overwrite))

  invisible(new_path)
}

#' Change ownership or group of a file
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

  invisible(path)
}

#' Open the file(s) directory in an interactive explorer
#'
#' @template fs
#' @return The directories that were opened (invisibly).
#' @importFrom utils browseURL
#' @export
file_show <- function(path = ".") {
  dirs <- path
  dirs[is_file(path)] <- dirname(path)

  for (p in dirs) {
    browseURL(p)
  }

  invisible(dirs)
}
