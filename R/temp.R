env <- new.env(parent = emptyenv())
env$temp_names <- character()

#' Create names for temporary files
#'
#' `file_temp()` returns the name which can be used as a temporary file.
#'
#' `file_temp_push()` can be used to supply deterministic entries in the
#' temporary file stack. This can be useful for reproducibility in like example
#' documentation and vignettes.
#'
#' `file_temp_pop()` can be used to explicitly remove an entry from the
#' internal stack, however generally this is done instead by calling
#' `file_temp()`.
#' @param pattern A character vector with the non-random portion of the name.
#' @param tmp_dir The directory the file will be created in.
#' @param ext The file extension of the temporary file.
#' @template fs
#' @export
#' @examples
#' \dontshow{file_temp_push("/tmp/filedd461c46df20")}
#' # default just passes the arguments to `tempfile()`
#' file_temp()
#'
#' # But you can also make the results deterministic
#' file_temp_push(letters)
#' file_temp()
#' file_temp()
#'
#' # Or explicitly remove values
#' while (!is.null(file_temp_pop())) next
#' file_temp_pop()
file_temp <- function(pattern = "file", tmp_dir = tempdir(), ext = "") {
  assert_no_missing(tmp_dir)

  tmp_dir <- path_expand(tmp_dir)

  path_tidy(file_temp_pop() %||% tempfile(pattern, tmp_dir, ext))
}

#' @export
#' @rdname file_temp
file_temp_push <- function(path) {
  assert_no_missing(path)

  path <- path_expand(path)

  env$temp_names <- c(env$temp_names, path)

  invisible(path_tidy(path))
}


#' @export
#' @rdname file_temp
file_temp_pop <- function() {
  n <- length(env$temp_names)
  if (n == 0) {
    return(NULL)
  }

  out <- env$temp_names[[1]]
  env$temp_names <- env$temp_names[-1]
  path_tidy(out)
}
