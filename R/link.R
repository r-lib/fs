#' Read the value of a symbolic link
#'
#' @return A tidy path to the object the link points to.
#' @template fs
#' @export
#' @examples
#' \dontshow{.old_wd <- setwd(tempdir())}
#' file_create("foo")
#' link_create(path_abs("foo"), "bar")
#' link_path("bar")
#'
#' # Cleanup
#' file_delete(c("foo", "bar"))
#' \dontshow{setwd(.old_wd)}
link_path <- function(path) {
  assert_no_missing(path)

  old <- path_expand(path)

  path_tidy(.Call(fs_readlink_, old))
}
