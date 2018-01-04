path_file_sanitize <- function(path) {
  dir <- path_dir(path)
  file <- path_file(path)
  illegal <- "[/\\?<>\\:*|\":]"
  control <- "[\x01-\x1f\x80-\x9f]"
  reserved <- "^[.]+$"
  windows_reserved <- "^(con|prn|aux|nul|com[0-9]|lpt[0-9])([.].*)?$"
  windows_trailing <- "[. ]+$"

  file <- gsub(illegal, "", file)
  file <- gsub(control, "", file)
  file <- gsub(reserved, "", file)
  file <- gsub(windows_reserved, "", file, ignore.case = TRUE)
  file <- gsub(windows_trailing, "", file)
  file <- substr(file, 1, 255)
  path(dir, file)
}
