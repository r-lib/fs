#' File permissions
#'
#' @param x An object which is to be coerced to a fmode object. Can be an
#'   number or octal character representation, including symbolic
#'   representations.
#' @examples
#' # Integer and numeric
#' fmode(420L)
#' fmode(c(511, 420))
#'
#' # Octal
#' fmode("777")
#' fmode(c("777", "644"))
#'
#' # Symbolic
#' fmode("a+rwx")
#' fmode(c("a+rwx", "u+rw,go+r"))
#' @export
#' @name fmode
as_fmode <- function(x) {
  UseMethod("as_fmode")
}

#' @export
#' @rdname fmode
fmode <- as_fmode

#' @export
print.fmode <- function(x, ...) {
  print(format(x, ...), quote = FALSE)

  invisible(x)
}

#' @export
format.fmode <- function(x, ...) {
  vapply(x, strmode_, character(1))
}

#' @export
as.character.fmode <- format.fmode

#' @export
`[.fmode` <- function(x, i) {
  new_fmode(NextMethod("["))
}

#' @export
as_fmode.fmode <- identity

#' @export
as_fmode.character <- function(x) {
  # matches inputs in rwxrwxrwx mode
  res <- x

  is_display_mode <- grepl("[rwxXst-]{9}", x)
  res[is_display_mode] <- display_mode_to_symbolic_mode(res[is_display_mode])
  res <- vapply(res, getmode_, integer(1), USE.NAMES = FALSE)
  structure(res, class = "fmode")
}

display_mode_to_symbolic_mode <- function(x) {
  paste0("u+", substring(x, 1, 3), ",g+", substring(x, 4,6), ",o+", substring(x, 7, 9))
}

#' @export
as_fmode.octmode <- function(x) {
  class(x) <- "fmode"
  x
}

#' @export
as_fmode.numeric <- function(x) {
  if (all(is.na(x) | x == as.integer(x))) {
    x <- as.integer(x)
    return(structure(x, class = "fmode"))
  }
  stop("'x' cannot be coerced to class \"fmode\"", call. = FALSE)
}

#' @export
as_fmode.integer <- function(x) {
  return(structure(x, class = "fmode"))
}

new_fmode <- function(x) {
  stopifnot(is.integer(x))
  structure(x, class = "fmode")
}

#' @export
`!.fmode` <- function(a) {
  new_fmode(bitwNot(a))
}

#' @export
`&.fmode` <- function(a, b) {
  new_fmode(bitwAnd(a, as_fmode(b)))
}

#' @export
`|.fmode` <- function(a, b) {
  new_fmode(bitwOr(a, as_fmode(b)))
}

#' @export
`==.fmode` <- function(a, b) {
  b <- as_fmode(b)
  unclass(a & b) == unclass(b)
}
