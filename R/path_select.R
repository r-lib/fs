#' Select path components by their position/index.
#'
#' `path_select_components()` allows to select individual components from
#' an `fs_path` object via their index.
#'
#' `path_select_components()` is vectorized.
#'
#' @param path A path of class `fs_path`.
#' @param index An integer vector of path positions. (A negative index will work
#'  according to R's usual subsetting rules.)
#' @param from A character of either `"start"` or `"end"` to choose if indexing
#'  should start from the first or last component of the `path`.
#'
#' @return An `fs_path` object, which is a character vector that also has class
#'  `fs_path`.
#'
#' @export
#' @examples
#' path <- fs::path("some", "simple", "path", "to", "a", "file.txt")
#'
#' path_select_components(path, 1:3)
#'
#' path_select_components(path, 1:3, "end")
#'
#' path_select_components(path, -1, "end")
#'
#' path_select_components(path, 6)

path_select_components <- function(path, index, from = c("start", "end")) {
  from <- match.arg(from)

  res <- fs_path(character(length(path)))
  ps <- fs::path_split(path)
  for (idx in seq_along(ps)) {
    path <- ps[[idx]]
    path_seq <- seq_along(path)

    if (length(index) > 0 && max(abs(index)) > length(path)) {
      stop("`seq` contains a higher number than the path has components.")
    }

    if (from == "start") {
      path <- path[index]
    }
    if (from == "end") {
      path_seq <- rev(rev(path_seq)[index])
      path <- path[path_seq]
    }

    res[idx] <- fs::path_join(path)
  }

  res
}
