# Ops.fs_bytes: errors for unary operators

    Code
      !x
    Condition
      Error:
      ! unary '!' not defined for "fs_bytes" objects
    Code
      +x
    Condition
      Error:
      ! unary '+' not defined for "fs_bytes" objects
    Code
      -x
    Condition
      Error:
      ! unary '-' not defined for "fs_bytes" objects

# Ops.fs_bytes: errors for other binary operators

    Code
      x %% 2
    Condition
      Error:
      ! '%%' not defined for "fs_bytes" objects
    Code
      x %/% 2
    Condition
      Error:
      ! '%/%' not defined for "fs_bytes" objects
    Code
      x & TRUE
    Condition
      Error:
      ! '&' not defined for "fs_bytes" objects
    Code
      x | TRUE
    Condition
      Error:
      ! '|' not defined for "fs_bytes" objects

