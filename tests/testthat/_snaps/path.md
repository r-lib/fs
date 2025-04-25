# path: errors on paths which are too long

    Code
      path(paste(rep("a", 1e+05), collapse = ""))
    Condition
      Error in `path_tidy()`:
      ! Total path length must be less than PATH_MAX: 1024
    Code
      do.call(path, as.list(rep("a", 1e+05)))
    Condition
      Error in `path_tidy()`:
      ! Total path length must be less than PATH_MAX: 1024

# path_rel: works for POSIX paths

    Code
      path_rel(c("a", "a/b", "a/b/c"), c("a/b", "a"))
    Condition
      Error:
      ! `start` must be a single path to a starting directory.

