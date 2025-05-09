with_dir_tree <- function(files, code, base = tempfile()) {
  if (is.null(names(files))) {
    names(files) <- rep("", length(files))
  }
  dirs <- dirname(names(files))
  unnamed <- dirs == ""
  dirs[unnamed] <- files[unnamed]
  files[unnamed] <- list(NULL)

  dir_create(path(base, dirs))
  old_wd <- setwd(base)
  on.exit({
    unlink(base, recursive = TRUE, force = TRUE)
    setwd(old_wd)
  })

  for (i in seq_along(files)) {
    if (!is.null(files[[i]])) {
      writeLines(files[[i]], con = names(files)[[i]])
    }
  }
  force(code)
}

expect_error_free <- function(...) {
  expect_error(..., regexp = NA)
}

skip_if_not_utf8 <- function() {
  skip_if_not(l10n_info()$`UTF-8`)
}

named_fs_path <- function(x) {
  new_fs_path(stats::setNames(x, x))
}

transform_error <- function(x) {
  sub("Error in `.*[(][)]`:", "Error:", x)
}

transform_path_max <- function(x) {
  sub("PATH_MAX: [0-9]+", "PATH_MAX: <path-max>", x)
}
