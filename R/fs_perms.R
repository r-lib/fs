#' File permissions
#'
#' @param x An object which is to be coerced to a fs_perms object. Can be an
#'   number or octal character representation, including symbolic
#'   representations.
#' @examples
#' # Integer and numeric
#' fs_perms(420L)
#' fs_perms(c(511, 420))
#'
#' # Octal
#' fs_perms("777")
#' fs_perms(c("777", "644"))
#'
#' # Symbolic
#' fs_perms("a+rwx")
#' fs_perms(c("a+rwx", "u+rw,go+r"))
#' @export
#' @name fs_perms
as_fmode <- function(x) {
  UseMethod("as_fmode")
}

#' @export
#' @rdname fs_perms
fs_perms <- as_fmode

#' @export
print.fs_perms <- function(x, ...) {
  print(format(x, ...), quote = FALSE)

  invisible(x)
}

#' @export
format.fs_perms <- function(x, ...) {
  vapply(x, strmode_, character(1))
}

#' @export
as.character.fs_perms <- format.fs_perms

#' @export
`[.fs_perms` <- function(x, i) {
  new_fmode(NextMethod("["))
}

#' @export
as_fmode.fs_perms <- identity

#' @export
as_fmode.character <- function(x) {
  # matches inputs in rwxrwxrwx mode
  res <- x

  is_display_mode <- grepl("[rwxXst-]{9}", x)
  res[is_display_mode] <- display_mode_to_symbolic_mode(res[is_display_mode])
  res <- vapply(res, getmode_, integer(1), USE.NAMES = FALSE)
  structure(res, class = "fs_perms")
}

display_mode_to_symbolic_mode <- function(x) {
  paste0("u+", substring(x, 1, 3), ",g+", substring(x, 4,6), ",o+", substring(x, 7, 9))
}

#' @export
as_fmode.octmode <- function(x) {
  class(x) <- "fs_perms"
  x
}

#' @export
as_fmode.numeric <- function(x) {
  if (all(is.na(x) | x == as.integer(x))) {
    x <- as.integer(x)
    return(structure(x, class = "fs_perms"))
  }
  stop("'x' cannot be coerced to class \"fs_perms\"", call. = FALSE)
}

#' @export
as_fmode.integer <- function(x) {
  return(structure(x, class = "fs_perms"))
}

new_fmode <- function(x) {
  stopifnot(is.integer(x))
  structure(x, class = "fs_perms")
}

#' @export
`!.fs_perms` <- function(a) {
  new_fmode(bitwNot(a))
}

#' @export
`&.fs_perms` <- function(a, b) {
  new_fmode(bitwAnd(a, as_fmode(b)))
}

#' @export
`|.fs_perms` <- function(a, b) {
  new_fmode(bitwOr(a, as_fmode(b)))
}

#' @export
`==.fs_perms` <- function(a, b) {
  b <- as_fmode(b)
  unclass(a & b) == unclass(b)
}
