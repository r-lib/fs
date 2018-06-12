base_functions <- c(
  "file.append",
  "Sys.setFileTime",
  "file.mode",
  "file.mtime",
  "file.size",
  "Sys.umask",
  "dir.create",
  "dir",
  "file.access",
  "Sys.chmod",
  "file.copy",
  "file.create",
  "file.remove",
  "unlink",
  "file.info",
  "file.rename",
  "dir.exists",
  "file.exists",
  "file.symlink",
  "file.link",
  "Sys.readlink",
  "file.path",
  "path.expand",
  "normalizePath",
  "tempdir")

base_fs_funs <- function(path = ".") {
  lintr::lint_package(path = path,
    linters = list(base_fs_linter = function(source_file) {
      goodpractice:::dangerous_functions_linter(source_file,
        funcs = c("file.rename", "file.create", "file.exists"),
        type = "warning",
        msg = "Avoid base filesystem functions",
        linter = "base_fs_linter") 
  }))
}
