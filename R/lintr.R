base_functions <- c(
  "Sys.chmod",
  "Sys.readlink",
  "Sys.setFileTime",
  "Sys.umask",
  "dir",
  "dir.create",
  "dir.exists",
  "file.access",
  "file.append",
  "file.copy",
  "file.create",
  "file.exists",
  "file.info",
  "file.link",
  "file.mode",
  "file.mtime",
  "file.path",
  "file.remove",
  "file.rename",
  "file.size",
  "file.symlink",
  "list.files",
  "list.dirs",
  "normalizePath",
  "path.expand",
  "tempdir",
  "tempfile",
  "unlink")

function_linter <- function(source_file, funcs, type,
  msg, linter) {

  bad <- which(
    source_file$parsed_content$token == "SYMBOL_FUNCTION_CALL" &
    source_file$parsed_content$text %in% funcs
  )

  lapply(
    bad,
    function(line) {
      parsed <- source_file$parsed_content[line, ]
      msg <- gsub("%s", source_file$parsed_content$text[line], msg)
      lintr::Lint(
        filename = source_file$filename,
        line_number = parsed$line1,
        column_number = parsed$col1,
        type = type,
        message = msg,
        line = source_file$lines[as.character(parsed$line1)],
        ranges = list(c(parsed$col1, parsed$col2)),
        linter = linter
      )
    }
  )
}

base_fs_funs <- function(path = ".") {
  lintr::lint_package(path = path,
    linters = list(base_fs_linter = function(source_file) {
      function_linter(source_file,
        funcs = base_functions,
        type = "warning",
        msg = "Avoid base filesystem functions (%s)",
        linter = "base_fs_linter") 
  }))
}
