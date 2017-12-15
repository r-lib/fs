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
