#' Rename a file
#'
#' @template fs
#' @param new_path new file path
#' @export
file_move <- function(path, new_path) {
  path <- path_expand(path)
  new_path <- path_expand(new_path)

  stopifnot(length(path) == length(new_path))

  move_(path, new_path)

  invisible(new_path)
}

#' Query file metadata
#' @template fs
#' @return A tibble with metadata for each file
#' @importFrom tibble as_tibble
#' @export
file_info <- function(path) {
  path <- path_expand(path)

  res <- stat_(path)

  types <- c("block_device", "character_device", "directory", "FIFO", "symlink", "file", "socket")
  res$type <- factor(res$type, levels = seq_along(types) - 1, labels = types)

  # TODO: convert to UTC times?
  res$access_time <- .POSIXct(res$access_time)
  res$modification_time <- .POSIXct(res$modification_time)
  res$creation_time <- .POSIXct(res$creation_time)
  res$birth_time <- .POSIXct(res$birth_time)

  as_tibble(res)
}

#' Check if a file exists
#' @template fs
#' @export
file_exists <- function(path) {
  file_access(path, "exists")
}

access_types <- c("exists" = 0L, "read" = 4L, "write" = 2L, "execute" = 1L)

#' Query files for access permissions
#' @template fs
#' @param mode A character vector containing one or more of 'exists', 'read',
#'   'write', 'execute'.
#' @return A logical vector
file_access <- function(path, mode = "exists") {
  path <- path_expand(path)
  mode <- match.arg(mode, names(access_types), several.ok = TRUE)
  mode <- sum(access_types[mode])

  access_(path, mode)
}

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
#' file_chmod(x, "ug+wr")
#' file_info(x)$permissions
file_chmod <- function(path, mode) {
  stopifnot(length(mode) == 1)
  chmod_(path_expand(path), mode)

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

  # TODO: not sure if this should return the path or not.
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
}

#' Change ownership or group of a file
#' @template fs
#' @param user_id The user id of the new owner, the R process must be privlaged to change
#'   this.
#' @param group_id The group id of the new owner
#' @export
file_chown <- function(path, user_id = NULL, group_id = NULL) {
  path <- path_expand(path)

  if (is.null(user_id)) {
    user_id <- -1
  }

  if (is.null(group_id)) {
    group_id <- -1
  }

  # TODO: use [getpwnam(3)](https://linux.die.net/man/3/getpwnam),
  # [getgrnam(3)](https://linux.die.net/man/3/getgrnam) to support specifying
  # uid / gid as names in addition to integers.
  chown_(path, user_id, group_id)

  invisible(path)
}
