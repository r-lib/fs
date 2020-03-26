#' Create, modify and view file permissions
#'
#' `fs_perms()` objects help one create and modify file permissions easily.
#' They support both numeric input, octal and symbolic character
#' representations. Compared to [octmode] they support symbolic representations
#' and display the mode the same format as `ls` on POSIX systems.
#'
#' @details
#' On POSIX systems the permissions are displayed as a 9 character string with
#' three sets of three characters. Each set corresponds to the permissions for
#' the user, the group and other (or default) users.
#'
#' If the first character of each set is a "r", the file is readable for those
#' users, if a "-", it is not readable.
#'
#' If the second character of each set is a "w", the file is writable for those
#' users, if a "-", it is not writable.
#'
#' The third character is more complex, and is the first of the following
#' characters which apply.
#' - 'S' If the character is part of the owner permissions and the file is not
#'   executable or the directory is not searchable by the owner, and the
#'   set-user-id bit is set.
#' - 'S' If the character is part of the group permissions and the file is not
#'   executable or the directory is not searchable by the group, and the
#'   set-group-id bit is set.
#' - 'T' If the character is part of the other permissions and the file is not
#'   executable or the directory is not searchable by others, and the 'sticky'
#'   (S_ISVTX) bit is set.
#' - 's' If the character is part of the owner permissions and the file is
#'   executable or the directory searchable by the owner, and the set-user-id bit
#'   is set.
#' - 's' If the character is part of the group permissions and the file is
#'   executable or the directory searchable by the group, and the set-group-id
#'   bit is set.
#' - 't' If the character is part of the other permissions and the file is
#'   executable or the directory searchable by others, and the ''sticky''
#'   (S_ISVTX) bit is set.
#' - 'x' The file is executable or the directory is searchable.
#' - '-' If none of the above apply.
#' Most commonly the third character is either 'x' or `-`.
#'
#' On Windows the permissions are displayed as a 3 character string where the
#' third character is only `-` or `x`.
#' @param x An object which is to be coerced to a fs_perms object. Can be an
#'   number or octal character representation, including symbolic
#'   representations.
#' @param ... Additional arguments passed to methods.
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
#'
#' # Use the `&` and `|`operators to check for certain permissions
#' (fs_perms("777") & "u+r") == "u+r"
#' @export
#' @name fs_perms
as_fs_perms <- function(x, ...) {
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
`[[.fs_perms` <- function(x, i) {
  new_fs_perms(NextMethod("[["))
}

#' @export
as_fs_perms.fs_perms <- function(x, ...) x

#' @export
as_fs_perms.character <- function(x, ..., mode = 0) {
  # matches inputs in rwxrwxrwx mode
  res <- x

  if (!is_windows()) {
    is_display_mode <- grepl("^[rwxXst-]{9}$", x)
    res[is_display_mode] <- display_mode_to_symbolic_mode_posix(res[is_display_mode])
  } else {
    is_display_mode <- grepl("^[rwxXst-]{3}$", x)
    res[is_display_mode] <- display_mode_to_symbolic_mode_windows(res[is_display_mode])
  }

  if (length(x) > 1 && length(mode) > 1 && length(x) != length(mode)) {

    msg <- sprintf(paste0(
        "`x` and `mode` must have compatible lengths:\n",
        "* `x` has length %i\n",
        "* `mode` has length %i\n"), length(x), length(mode))


    stop(fs_error(msg))
  }

  # Recycled over both res and mode
  n <- max(length(res), length(mode))
  out <- integer(n)
  for (i in seq_len(n)) {
    out[[i]] <- as.integer(
      .Call(getmode_,
        res[[((i + 1) %% length(res)) + 1L]],
        as.integer(mode[[((i + 1) %% length(mode)) + 1L]])))
  }
  new_fs_perms(out)
}

display_mode_to_symbolic_mode_posix <- function(x) {
  paste0("u=", substring(x, 1, 3), ",g=", substring(x, 4,6), ",o=", substring(x, 7, 9))
}
display_mode_to_symbolic_mode_windows <- function(x) {
  paste0("u=", substring(x, 1, 3))
}

#' @export
as_fs_perms.octmode <- function(x, ...) {
  class(x) <- c("fs_perms", "integer")
  x
}

#' @export
as_fs_perms.numeric <- function(x, ...) {
  if (all(is.na(x) | x == as.integer(x))) {
    x <- as.integer(x)
    return(new_fs_perms(x))
  }
  stop("'x' cannot be coerced to class \"fs_perms\"", call. = FALSE)
}

#' @export
as_fs_perms.integer <- function(x, ...) {
  new_fs_perms(x)
}

new_fs_perms <- function(x) {
  assert("`x` must be an integer", is.integer(x))
  structure(x, class = c("fs_perms", "integer"))
}
setOldClass(c("fs_perms", "integer"), integer())

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
