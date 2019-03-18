#' Print contents of directories in a tree-like format
#'
#' @param path A path to print the tree from
#' @export
dir_tree <- function(path) {
  files <- dir_ls(path, recursive = TRUE)
  by_dir <- split(files, path_dir(files))

  ch <- box_chars()

  get_coloured_name <- function(x) {
    coloured <- colourise_fs_path(x)
    sub(x, path_file(x), coloured)
  }

  print_leaf <- function(x, indent) {
    leafs <- by_dir[[x]]
    for (i in seq_along(leafs)) {
      if (i == length(leafs)) {
        cat(indent, pc(ch$l, ch$h, ch$h), get_coloured_name(leafs[[i]]), "\n", sep = "")
        print_leaf(leafs[[i]], paste0(indent, "   "))
      } else {
        cat(indent, pc(ch$j, ch$h, ch$h), get_coloured_name(leafs[[i]]), "\n", sep = "")
        print_leaf(leafs[[i]], paste0(indent, pc(ch$v, "  ")))
      }
    }
  }

  cat(colourise_fs_path(path), "\n", sep = "")
  print_leaf(path, "")

  invisible(files)
}

pc <- function(...) {
  paste0(..., collapse = "")
}

box_chars <- function() {
  if (is_utf8_output()) {
    list(
      "h" = "\u2500",                   # horizontal
      "v" = "\u2502",                   # vertical
      "l" = "\u2514",
      "j" = "\u251C"
    )
  } else {
    list(
      "h" = "-",                        # horizontal
      "v" = "|",                        # vertical
      "l" = "\\",
      "j" = "+"
    )
  }
}

is_latex_output <- function() {
  if (!("knitr" %in% loadedNamespaces())) return(FALSE)
  get("is_latex_output", asNamespace("knitr"))()
}

is_utf8_output <- function() {
  opt <- getOption("cli.unicode", NULL)
  if (! is.null(opt)) {
    isTRUE(opt)
  } else {
    l10n_info()$`UTF-8` && !is_latex_output()
  }
}
