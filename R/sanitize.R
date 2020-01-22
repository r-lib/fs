#' Sanitize a filename by removing directory paths and invalid characters
#'
#' `path_sanitize()` removes the following:
#' - [Control characters](https://en.wikipedia.org/wiki/C0_and_C1_control_codes)
#' - [Reserved characters](https://kb.acronis.com/content/39790)
#' - Unix reserved filenames (`.` and `..`)
#' - Trailing periods and spaces (invalid on Windows)
#' - Windows reserved filenames (`CON`, `PRN`, `AUX`, `NUL`, `COM1`, `COM2`,
#'   `COM3`, COM4, `COM5`, `COM6`, `COM7`, `COM8`, `COM9`, `LPT1`, `LPT2`,
#'   `LPT3`, `LPT4`, `LPT5`, `LPT6`, LPT7, `LPT8`, and `LPT9`)
#' The resulting string is then truncated to [255 bytes in length](https://en.wikipedia.org/wiki/Comparison_of_file_systems#Limits)
#' @param filename A character vector to be sanitized.
#' @param replacement A character vector used to replace invalid characters.
#' @seealso <https://www.npmjs.com/package/sanitize-filename>, upon which this
#'   function is based.
#' @export
#' @examples
#' # potentially unsafe string
#' str <- "~/.\u0001ssh/authorized_keys"
#' path_sanitize(str)
#'
#' path_sanitize("..")
path_sanitize <- function(filename, replacement = "") {
  illegal <- "[/\\?<>\\:*|\":]"
  control <- "[[:cntrl:]]"
  reserved <- "^[.]+$"
  windows_reserved <- "^(con|prn|aux|nul|com[0-9]|lpt[0-9])([.].*)?$"
  windows_trailing <- "[. ]+$"

  filename <- gsub(illegal, replacement, filename)
  filename <- gsub(control, replacement, filename)
  filename <- gsub(reserved, replacement, filename)
  filename <- gsub(windows_reserved, replacement, filename, ignore.case = TRUE)
  filename <- gsub(windows_trailing, replacement, filename)

  # TODO: this substr should really be unicode aware, so it doesn't chop a
  # multibyte code point in half.
  filename <- substr(filename, 1, 255)
  if (replacement == "") {
    return(filename)
  }
  path_sanitize(filename, "")
}
