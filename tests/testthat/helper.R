with_dir_tree <- function(files, code, base = tempfile()) {
  dir_create(path(base, dirname(names(files))))
  old_wd <- setwd(base)
  on.exit({
    unlink(base, recursive = TRUE)
    setwd(old_wd)
  })

  for (i in seq_along(files)) {
    writeLines(files[[i]], con = names(files)[[i]])
  }
  force(code)
}
