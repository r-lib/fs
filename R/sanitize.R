path_file_sanitize <- function(file, replacement = "") {
  illegal <- "[/\\?<>\\:*|\":]"
  control <- "[[:cntrl:]]"
  reserved <- "^[.]+$"
  windows_reserved <- "^(con|prn|aux|nul|com[0-9]|lpt[0-9])([.].*)?$"
  windows_trailing <- "[. ]+$"

  file <- gsub(illegal, replacement, file)
  file <- gsub(control, replacement, file, perl = TRUE)
  file <- gsub(reserved, replacement, file)
  file <- gsub(windows_reserved, replacement, file, ignore.case = TRUE)
  file <- gsub(windows_trailing, replacement, file)
  if (replacement == "") {
    return(file)
  }
  path_file_sanitize(file, "")
}
