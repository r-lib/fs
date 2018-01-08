#' Create, modify and view file permissions
#'
#' `fs_perms()` objects help one create and modify file permissions easily.
#' They support both numeric input, octal and symbolic character
#' representations. Compared to [octmode] they support symbolic representations
#' and display the mode the same format as `ls` on POSIX systems.
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
as_fs_perms <- function(x) {
  UseMethod("as_fs_perms")
}

#' @export
#' @rdname fs_perms
fs_perms <- as_fs_perms

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
  new_fs_perms(NextMethod("["))
}

#' @export
as_fs_perms.fs_perms <- identity

#' @export
as_fs_perms.character <- function(x) {
  # matches inputs in rwxrwxrwx mode
  res <- x

  if (!is_windows()) {
    is_display_mode <- grepl("^[rwxXst-]{9}$", x)
    res[is_display_mode] <- display_mode_to_symbolic_mode_posix(res[is_display_mode])
  } else {
    is_display_mode <- grepl("^[rwxXst-]{3}$", x)
    res[is_display_mode] <- display_mode_to_symbolic_mode_windows(res[is_display_mode])
  }
  res <- as.integer(lapply(res, getmode_, mode = 0))
  structure(res, class = "fs_perms")
}

display_mode_to_symbolic_mode_posix <- function(x) {
  paste0("u=", substring(x, 1, 3), ",g+", substring(x, 4,6), ",o+", substring(x, 7, 9))
}
display_mode_to_symbolic_mode_windows <- function(x) {
  paste0("u=", substring(x, 1, 3))
}

#' @export
as_fs_perms.octmode <- function(x) {
  class(x) <- "fs_perms"
  x
}

#' @export
as_fs_perms.numeric <- function(x) {
  if (all(is.na(x) | x == as.integer(x))) {
    x <- as.integer(x)
    return(structure(x, class = "fs_perms"))
  }
  stop("'x' cannot be coerced to class \"fs_perms\"", call. = FALSE)
}

#' @export
as_fs_perms.integer <- function(x) {
  return(structure(x, class = "fs_perms"))
}

new_fs_perms <- function(x) {
  stopifnot(is.integer(x))
  structure(x, class = "fs_perms")
}

#' @export
`!.fs_perms` <- function(a) {
  new_fs_perms(bitwNot(a))
}

#' @export
`&.fs_perms` <- function(a, b) {
  new_fs_perms(bitwAnd(a, as_fs_perms(b)))
}

#' @export
`|.fs_perms` <- function(a, b) {
  new_fs_perms(bitwOr(a, as_fs_perms(b)))
}

#' @export
`==.fs_perms` <- function(a, b) {
  b <- as_fs_perms(b)
  unclass(a & b) == unclass(b)
}

pillar_shaft.fs_perms <- function(x, ...) {
  pillar::new_pillar_shaft_simple(format.fs_perms(x), ...)
}

type_sum.fs_perms <- function(x) {
  "fs::perms"
}
