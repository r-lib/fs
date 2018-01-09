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
    unlink(base, recursive = TRUE)
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
