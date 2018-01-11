#' Read the value of a symbolic link
#'
#' @return A tidy path to the object the link points to.
#' @template fs
#' @export
#' @examples
#' file_create("foo")
#' link_create(path_abs("foo"), "bar")
#' link_path("bar")
#' file_delete(c("foo", "bar"))
link_path <- function(path) {
  path <- path_expand(path)

  path_tidy(readlink_(path))
}
