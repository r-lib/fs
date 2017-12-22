units <- c('B' = 1, 'K' = 1024, 'M' = 1024 ^ 2, 'G' = 1024 ^ 3, 'T' = 1024 ^ 4, 'P' = 1024 ^ 5, 'E' = 1024 ^ 6, 'Z' = 1024 ^ 7, 'Y' = 1024 ^ 8)

#' @export
# Adapted from https://github.com/gaborcsardi/prettyunits
# Aims to be consistent with ls -lh, so uses 1024 KiB units, 3 or less digits etc.
format.fs_bytes <- function(x, scientific = FALSE, digits = 3, ...) {
  bytes <- unclass(x)

  exponent <- pmin(floor(log(bytes, 1024)), length(units) - 1)
  res <- round(bytes / 1024 ^ exponent, 2)
  unit <- ifelse (exponent == 0, "", names(units)[exponent + 1])

  ## Zero bytes
  res[bytes == 0] <- 0
  unit[bytes == 0] <- names(units)[1]

  ## NA and NaN bytes
  res[is.na(bytes)] <- NA_real_
  res[is.nan(bytes)] <- NaN
  unit[is.na(bytes)] <- ""            # Includes NaN as well

  res <- format(res, scientific = scientific, digits = digits, drop0trailing = TRUE, ...)

  paste0(res, unit)
}

#' @export
as.character.fs_bytes <- format.fs_bytes

#' @export
print.fs_bytes <- function(x, ...) {
  cat(format.fs_bytes(x, ...))
}

#' Coerce an object to a fs_bytes object
#' @param x Object to be coerced
#' @examples
#' as_fs_bytes("1KB") < "1MB"
#' @export
as_fs_bytes <- function(x) {
  if (inherits(x, "fs_bytes")) {
    return(x)
  }
  if (is.numeric(x)) {
    return(structure(x, class = "fs_bytes"))
  }
  x <- as.character(x)
  m <- captures(x, regexpr("^(?<size>[[:digit:].]+)\\s*(?<unit>[KMGTPEZY]?)i?[Bb]?$", x, perl = TRUE))
  m$unit[m$unit == ""] <- "B"
  structure(as.numeric(m$size) * units[m$unit], class = "fs_bytes")
}

#' @export
sum.fs_bytes <- function(x, ...) {
  as_fs_bytes(NextMethod())
}

#' @export
`[.fs_bytes` <- function(x, i) {
  cl <- oldClass(x)
  y <- NextMethod("[")
  oldClass(y) <- cl
  y
}

#' @export
# Adapted from Ops.numeric_version
Ops.fs_bytes <- function (e1, e2) {
  if (nargs() == 1L) {
    stop(gettextf("unary '%s' not defined for \"fs_bytes\" objects",
        .Generic), domain = NA)
  }
  boolean <- switch(.Generic, `<` = , `>` = , `==` = , `!=` = ,
    `<=` = , `>=` = TRUE, FALSE)
  if (!boolean) {
    stop(gettextf("'%s' not defined for \"fs_bytes\" objects",
        .Generic), domain = NA)
  }
  e1 <- as_fs_bytes(e1)
  e2 <- as_fs_bytes(e2)
  NextMethod(.Generic)
}
