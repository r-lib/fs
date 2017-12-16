#' Rename a file
#'
#' @template fs
#' @param new_path new file path
#' @export
file_move <- function(path, new_path) {
  path <- enc2utf8(path)
  new_path <- enc2utf8(new_path)

  stopifnot(length(path) == length(new_path))

  # Expand only the directory portion of new_path
  new_path <- path(dirname(path_expand(new_path)), basename(new_path))

  move_(path_norm(path_expand(path)), new_path)

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
#' template fs
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
