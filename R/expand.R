#' Perform tilde expansion of a pathname
#'
#' equivalent to [base::path.expand]
#' @export
fs_expand <- function(path) {
  enc2utf8(path.expand(enc2utf8(path)))
}

# TODO: so far it looks like libuv does not provide a cross platform version of this https://github.com/libuv/libuv/issues/11
