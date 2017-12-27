#' Read the value of a symbolic link
#' @template fs
#' @examples
#' file_create("foo")
#' link_create(path_norm("foo"), "bar")
#' link_path("bar")
#' file_delete(c("foo", "bar"))
#' @export
link_path <- function(path) {
  path <- path_expand(path)

  readlink_(path)
}
