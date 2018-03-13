#' Construct a path to a location within an installed package
#'
#' `path_package` differs from [system.file()] in that it always returns an
#' error if the package does not exist. It also returns a different error if
#' the file within the package does not exist.
#'
#' @param package Name of the package to in which to search
#' @param ... Additional paths appended to the package path by [path()].
#' @examples
#' path_package("base")
#' path_package("stats")
#' path_package("base", "INDEX")
#' path_package("splines", "help", "AnIndex")
#' @export
path_package <- function(package, ...) {
  if (!is.character(package) || length(package) != 1L) {
    stop(fs_error(sprintf("`package` must be a character vector of length 1")))
  }

  pkg_path <-
    tryCatch(
      find.package(package, quiet = FALSE),

      error = function(error) {
        is_not_found_error <- grepl(
          gettextf("there is no package called %s", sQuote(package)),
          conditionMessage(error), fixed = TRUE)
        if (!is_not_found_error) {
          stop(error)
        }

        msg <- sprintf(
"Can't find package `%s` in library locations:
%s",
    package,
    paste0("  - '", path_tidy(.libPaths()), "'", collapse = "\n"))

    stop(fs_error(msg, class = "EEXIST"))
    })

  p <- path(pkg_path, ...)
  if (!file_exists(p)) {
    msg <- sprintf(
      "File '%s' does not exist",
      p)
    stop(fs_error(msg, class = "EEXIST"))
  }
  p
}
