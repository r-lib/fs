captures <- function(x, m) {
  assert("`x` must be a character", is.character(x))
  assert("`m` must be a match object from `regexpr()`",
    inherits(m, "integer") &&
    all(c("match.length", "useBytes", "capture.start", "capture.length", "capture.names") %in% names(attributes(m))))

  starts <- attr(m, "capture.start")
  strings <- substring(x, starts, starts + attr(m, "capture.length") - 1L)
  res <- data.frame(matrix(strings, ncol = NCOL(starts)), stringsAsFactors = FALSE)
  colnames(res) <- auto_name(attr(m, "capture.names"))
  res[is.na(m) | m == -1, ] <- NA_character_
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

# This is needed to avoid checking the class of fs_path objects in the
# tests.
compare.fs_path <- function(x, y) {
  if (identical(class(y), "character")) {
    class(x) <- NULL
  }
  names(x) <- NULL
  names(y) <- NULL
  NextMethod("compare")
}

compare.fs_perms <- function(x, y) {
  if (!inherits(y, "fs_perms")) {
    y <- as.character(as_fs_perms(y))
    x <- as.character(x)
  }
  NextMethod("compare")
}

nchar <- function(x, type = "chars", allowNA = FALSE, keepNA = NA) {
  # keepNA was introduced in R 3.2.1, previous behavior was equivalent to keepNA
  # = FALSE
  if (getRversion() < "3.2.1") {
    if (!identical(keepNA, FALSE)) {
      stop("`keepNA` must be `FALSE` for R < 3.2.1", call. = FALSE)
    }
    return(base::nchar(x, type, allowNA))
  }
  base::nchar(x, type, allowNA, keepNA)
}

`%||%` <- function(x, y) if (is.null(x)) y else x

# Only use deterministic entries if we are building documentation in pkgdown.
pkgdown_tmp <- function(path) {
  if (identical(Sys.getenv("IN_PKGDOWN"), "true")) {
    file_temp_push(path)
  }
}

# This is adapted from glue::collapse
# https://github.com/tidyverse/glue/blob/cac874724d09d430036d1bdeba77982e953f29a2/R/glue.R#L140-L161
collapse <- function(x, sep = "", width = Inf, last = "") {
  if (length(x) == 0) {
    return(character())
  }
  if (any(is.na(x))) {
    return(NA_character_)
  }

  if (nzchar(last) && length(x) > 1) {
    res <- collapse(x[seq(1, length(x) - 1)], sep = sep, width = Inf)
    return(collapse(paste0(res, last, x[length(x)]), width = width))
  }
  x <- paste0(x, collapse = sep)
  if (width < Inf) {
    x_width <- nchar(x, "width", keepNA = FALSE)
    too_wide <- x_width > width
    if (too_wide) {
      x <- paste0(substr(x, 1, width - 3), "...")
    }
  }
  x
}

assert_no_missing <- function(x) {
  nme <- as.character(substitute(x))
  idx <- which(is.na(x))
  if (length(idx) > 0) {
    number <- prettyNum(length(idx), big.mark = ",")
    remaining_width <- getOption("width") - nchar(number, keepNA = FALSE) - 29
    indexes <- collapse(idx, width = remaining_width, sep = ", ", last = " and ")
    msg <- sprintf(
"`%s` must not have missing values
  * NAs found at %s locations: %s",
    nme,
    number,
    indexes)

    stop(fs_error(msg))
  }
}

assert <- function(msg, ..., class = "invalid_argument") {
  tests <- unlist(list(...))

  if (!all(tests)) {
    stop(fs_error(msg, ..., class = class))
  }
}

fs_error <- function(msg, class = "invalid_argument") {
  structure(class = c(class, "fs_error", "error", "condition"), list(message = msg))
}
