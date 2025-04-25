# as_fs_path: fails with non-character inputs

    Code
      as_fs_path(1)
    Condition
      Error in `UseMethod()`:
      ! no applicable method for 'as_fs_path' applied to an object of class "c('double', 'numeric')"
    Code
      as_fs_path(TRUE)
    Condition
      Error in `UseMethod()`:
      ! no applicable method for 'as_fs_path' applied to an object of class "logical"

