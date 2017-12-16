#' @export
print.fmode <- function(x, ...) {
  print(format(x, ...), quote = FALSE)

  invisible(x)
}

#' @export
format.fmode <- function(x, ...) {
  strmode_(x)
}

#' @export
as.character.fmode <- format.fmode

#' @export
`[.fmode` <- function(x, i) {
  cl <- oldClass(x)
  y <- NextMethod("[")
  oldClass(y) <- cl
  y
}

#' @rdname fmode
#' @export
as_fmode <- function(x) {
  if (inherits(x, "fmode")) {
    return(x)
  }
  if (inherits(x, "octmode")) {
    class(x) <- "fmode"
    return(x)
  }
  if (is.double(x) && all(is.na(x) | x == as.integer(x))) {
    x <- as.integer(x)
  }
  if (is.integer(x)) {
    return(structure(x, class = "fmode"))
  }
  if (is.character(x)) {
    return(structure(getmode_(x), class = "fmode"))
  }
  stop("'x' cannot be coerced to class \"fmode\"")
}

#' File permissions
#' @param x An object which is to be coerced to a fmode object. Can be an
#'   number or hexidecimal character representation, including symbolic
#'   representations.
#' @export
fmode <- as_fmode

#' @export
`!.fmode` <- function(a) {
  as_fmode(bitwNot(as_fmode(a)))
}

#' @export
`&.fmode` <- function(a, b) {
  as_fmode(bitwAnd(as_fmode(a), as_fmode(b)))
}

#' @export
`|.fmode` <- function(a, b) {
  as_fmode(bitwOr(as_fmode(a), as_fmode(b)))
}
