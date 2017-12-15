file_exists <- function(path) {
  path <- enc2utf8(path)
  exists_(path_expand(path))
}
