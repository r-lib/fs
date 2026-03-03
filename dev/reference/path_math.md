# Path computations

All functions apart from `path_real()` are purely path computations, so
the files in question do not need to exist on the filesystem.

## Usage

``` r
path_real(path)

path_split(path)

path_join(parts)

path_abs(path, start = ".")

path_norm(path)

path_rel(path, start = ".")

path_common(path)

path_has_parent(path, parent)
```

## Arguments

- path:

  A character vector of one or more paths.

- parts:

  A character vector or a list of character vectors, corresponding to
  split paths.

- start:

  A starting directory to compute the path relative to.

- parent:

  The parent path.

## Value

The new path(s) in an `fs_path` object, which is a character vector that
also has class `fs_path`. Except `path_split()`, which returns a list of
character vectors of path components.

## Functions

- `path_real()`: returns the canonical path, eliminating any symbolic
  links and the special references `~`, `~user`, `.`, and `..`, , i.e.
  it calls
  [`path_expand()`](https://fs.r-lib.org/dev/reference/path_expand.md)
  (literally) and `path_norm()` (effectively).

- `path_split()`: splits paths into parts.

- `path_join()`: joins parts together. The inverse of `path_split()`.
  See [`path()`](https://fs.r-lib.org/dev/reference/path.md) to
  concatenate vectorized strings into a path.

- `path_abs()`: returns a normalized, absolute version of a path.

- `path_norm()`: eliminates `.` references and rationalizes up-level
  `..` references, so `A/./B` and `A/foo/../B` both become `A/B`, but
  `../B` is not changed. If one of the paths is a symbolic link, this
  may change the meaning of the path, so consider using `path_real()`
  instead.

- `path_rel()`: computes the path relative to the `start` path, which
  can be either an absolute or relative path.

- `path_common()`: finds the common parts of two (or more) paths.

- `path_has_parent()`: determine if a path has a given parent.

## See also

[`path_expand()`](https://fs.r-lib.org/dev/reference/path_expand.md) for
expansion of user's home directory.

## Examples

``` r
dir_create("a")
file_create("a/b")
link_create(path_abs("a"), "c")

# Realize the path
path_real("c/b")
#> /tmp/RtmpgolSxg/a/b

# Split a path
parts <- path_split("a/b")
parts
#> [[1]]
#> [1] "a" "b"
#> 

# Join it together
path_join(parts)
#> a/b

# Find the absolute path
path_abs("..")
#> /tmp

# Normalize a path
path_norm("a/../b\\c/.")
#> b/c

# Compute a relative path
path_rel("/foo/abc", "/foo/bar/baz")
#> ../../abc

# Find the common path between multiple paths
path_common(c("/foo/bar/baz", "/foo/bar/abc", "/foo/xyz/123"))
#> /foo

# Cleanup
dir_delete("a")
link_delete("c")
```
