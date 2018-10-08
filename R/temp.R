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
#'
#' `path_temp()` constructs a path within the session temporary directory.
#' @param pattern A character vector with the non-random portion of the name.
#' @param tmp_dir The directory the file will be created in.
#' @param ext The file extension of the temporary file.
#' @param ... Additional paths appended to the temporary directory by `path()`.
#' @template fs
#' @export
#' @examples
#' \dontshow{file_temp_push("/tmp/filedd461c46df20")}
#'
#' path_temp()
#' path_temp("does-not-exist")
#'
#' file_temp()
#' file_temp(ext = "png")
#' file_temp("image", ext = "png")
#'
#'
#' # You can make the temp file paths deterministic
#' file_temp_push(letters)
#' file_temp()
#' file_temp()
#'
#' # Or explicitly remove values
#' while (!is.null(file_temp_pop())) next
#' file_temp_pop()
file_temp <- function(pattern = "file", tmp_dir = tempdir(), ext = "") {
  assert_no_missing(tmp_dir)

  prepend_dot <- function(ext) ifelse(nchar(ext), paste0(".", ext), ext)
  ext <- vapply(ext, prepend_dot, character(1))

  path_tidy(file_temp_pop() %||% tempfile(pattern, tmp_dir, ext))
}

#' @export
#' @rdname file_temp
file_temp_push <- function(path) {
  assert_no_missing(path)

  old <- path_expand(path)

  env$temp_names <- c(env$temp_names, old)

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

#' @export
#' @rdname file_temp
path_temp <- function(...) {
  path(tempdir(), ...)
}

