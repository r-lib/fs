units <- c('B' = 1, 'K' = 1024, 'M' = 1024 ^ 2, 'G' = 1024 ^ 3, 'T' = 1024 ^ 4, 'P' = 1024 ^ 5, 'E' = 1024 ^ 6, 'Z' = 1024 ^ 7, 'Y' = 1024 ^ 8)

#' Human readable file sizes
#'
#' Construct, manipulate and display vectors of file sizes. These are numeric
#' vectors, so you can compare them numerically, but they can also be compared
#' to human readable values such as '10MB'.
#'
#' @param x A numeric or character vector. Character representations can use
#'   shorthand sizes (see examples).
#' @examples
#' fs_bytes("1")
#' fs_bytes("1K")
#' fs_bytes("1Kb")
#' fs_bytes("1Kib")
#' fs_bytes("1MB")
#'
#' fs_bytes("1KB") < "1MB"
#'
#' sum(fs_bytes(c("1MB", "5MB", "500KB")))
#' @name fs_bytes
#' @export
as_fs_bytes <- function(x) {
  UseMethod("as_fs_bytes")
}

#' @export
#' @rdname fs_bytes
fs_bytes <- as_fs_bytes

new_fs_bytes <- function(x) {
  structure(x, class = c("fs_bytes", "numeric"))
}
setOldClass(c("fs_bytes", "numeric"), numeric())

#' @export
as_fs_bytes.default <- function(x = numeric()) {
  x <- as.character(x)
  m <- captures(x, regexpr("^(?<size>[[:digit:].]+)\\s*(?<unit>[KMGTPEZY]?)i?[Bb]?$", x, perl = TRUE))
  m$unit[m$unit == ""] <- "B"
  new_fs_bytes(unname(as.numeric(m$size) * units[m$unit]))
}

#' @export
as_fs_bytes.fs_bytes <- function(x) {
  return(x)
}

#' @export
as_fs_bytes.numeric <- function(x) {
  new_fs_bytes(x)
}

# Adapted from https://github.com/gaborcsardi/prettyunits
# Aims to be consistent with ls -lh, so uses 1024 KiB units, 3 or less digits etc.
#' @export
format.fs_bytes <- function(x, scientific = FALSE, digits = 3, drop0trailing = TRUE, ...) {
  bytes <- unclass(x)

  exponent <- pmin(floor(log(bytes, 1024)), length(units) - 1)
  res <- round(bytes / 1024 ^ exponent, 2)
  unit <- ifelse (exponent == 0, "", names(units)[exponent + 1])

  ## Zero bytes
  res[bytes == 0] <- 0
  unit[bytes == 0] <- ""

  ## NA and NaN bytes
  res[is.na(bytes)] <- NA_real_
  res[is.nan(bytes)] <- NaN
  unit[is.na(bytes)] <- ""            # Includes NaN as well

  res <- format(res, scientific = scientific, digits = digits, drop0trailing = drop0trailing, ...)

  paste0(res, unit)
}

#' @export
as.character.fs_bytes <- format.fs_bytes

#' @export
print.fs_bytes <- function(x, ...) {
  cat(format.fs_bytes(x, ...))
}

#' @export
sum.fs_bytes <- function(x, ...) {
  new_fs_bytes(NextMethod())
}

#' @export
min.fs_bytes <- function(x, ...) {
  new_fs_bytes(NextMethod())
}

#' @export
max.fs_bytes <- function(x, ...) {
  new_fs_bytes(NextMethod())
}

#' @export
`[.fs_bytes` <- function(x, i, ...) {
  new_fs_bytes(NextMethod("["))
}

#' @export
`[[.fs_bytes` <- function(x, i, ...) {
  new_fs_bytes(NextMethod("[["))
}

#' @export
# Adapted from Ops.numeric_version
Ops.fs_bytes <- function (e1, e2) {
  if (nargs() == 1L) {
    stop(sprintf("unary '%s' not defined for \"fs_bytes\" objects", .Generic),
      call. = FALSE)
  }

  boolean <- switch(.Generic,
    `+` = TRUE,
    `-` = TRUE,
    `*` = TRUE,
    `/` = TRUE,
    `^` = TRUE,
    `<` = TRUE,
    `>` = TRUE,
    `==` = TRUE,
    `!=` = TRUE,
    `<=` = TRUE,
    `>=` = TRUE,
  FALSE)
  if (!boolean) {
    stop(sprintf("'%s' not defined for \"fs_bytes\" objects", .Generic),
      call. = FALSE)
  }
  e1 <- as_fs_bytes(e1)
  e2 <- as_fs_bytes(e2)
  NextMethod(.Generic)
}

pillar_shaft.fs_bytes <- function(x, ...) {
  pillar::new_pillar_shaft_simple(format.fs_bytes(x), align = "right", ...)
}

type_sum.fs_bytes <- function(x) {
  "fs::bytes"
}

# All functions below registered in .onLoad

vec_ptype2.fs_bytes.fs_bytes <- function(x, y, ...) {
  x
}
vec_ptype2.fs_bytes.double <- function(x, y, ...) {
  x
}
vec_ptype2.double.fs_bytes <- function(x, y, ...) {
  y
}

# Note order of class is the opposite as for ptype2
vec_cast.fs_bytes.fs_bytes <- function(x, to, ...) {
  x
}
vec_cast.fs_bytes.double <- function(x, to, ...) {
  as_fs_bytes(x)
}
vec_cast.double.fs_bytes <- function(x, to, ...) {
  unclass(x)
}

vec_ptype2.fs_bytes.integer <- function(x, y, ...) {
  x
}
vec_ptype2.integer.fs_bytes <- function(x, y, ...) {
  y
}

vec_cast.fs_bytes.integer <- function(x, to, ...) {
  as_fs_bytes(x)
}
vec_cast.integer.fs_bytes <- function(x, to, ...) {
  unclass(x)
}
