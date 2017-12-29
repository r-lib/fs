captures <- function(x, m) {
  stopifnot(is.character(x))
  stopifnot(class(m) == "integer" &&
    all(c("match.length", "useBytes", "capture.start", "capture.length", "capture.names") %in% names(attributes(m))))

  starts <- attr(m, "capture.start")
  strings <- substring(x, starts, starts + attr(m, "capture.length") - 1L)
  res <- data.frame(matrix(strings, ncol = NCOL(starts)), stringsAsFactors = FALSE)
  colnames(res) <- auto_name(attr(m, "capture.names"))
  res[m == -1, ] <- NA_character_
  res
}

auto_name <- function(names) {
  missing <- names == ""
  if (all(!missing)) {
    return(names)
  }
  names[missing] <- seq_along(names)[missing]
  names
}

is_windows <- function() {
  tolower(Sys.info()[["sysname"]]) == "windows"
}

# This is needed to avoid checking the class of fs_filename objects in the
# tests.
compare.fs_filename <- function(x, y) {
  if (identical(class(y), "character")) {
    class(x) <- "character"
  }
  NextMethod("compare")
}
