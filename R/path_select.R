#' Select path elements by their position/index.
#'
#' `path_select()` allows to select individual elements from an `fs_path`
#'  object via their index.
#'
#' @param path A path of class `fs_path`.
#' @param index An integer vector of path positions. (A negative index will work
#'  according to R's usual subsetting rules.)
#' @param from A character of either `"start"` or `"end"` to choose if indexing
#'  should start from the first or last element of the `path`.
#'
#' @return An `fs_path` object, which is a character vector that also has class
#'  `fs_path`.
#'
#' @export
#' @examples
#' path <- fs::path("some", "simple", "path", "to", "a", "file.txt")
#'
#' path_select(path, 1:3)
#'
#' path_select(path, 1:3, "end")
#'
#' path_select(path, -1, "end")
#'
#' path_select(path, 6)
path_select <- function(path, index, from = c("start", "end")) {

  from <- match.arg(from)

  if (length(path) > 1) {stop("Please supply only one path.")}

  path <- unlist(fs::path_split(path))
  path_seq <- seq_along(path)

  if (max(abs(index)) > length(path)) {stop("`seq` contains a higher number than the path has elements.")}

  if (from == "start") {path <- path[index]}
  if (from == "end") {
    path_seq <- rev(rev(path_seq)[index])
    path <- path[path_seq]
  }

  path <- fs::path_join(path)

  return(path)
}
