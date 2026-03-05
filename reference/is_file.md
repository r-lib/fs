# Functions to test for file types

Functions to test for file types

## Usage

``` r
is_file(path, follow = TRUE)

is_dir(path, follow = TRUE)

is_link(path)

is_file_empty(path, follow = TRUE)
```

## Arguments

- path:

  A character vector of one or more paths.

- follow:

  If `TRUE`, symbolic links will be followed (recursively) and the
  results will be that of the final file rather than the link.

## Value

A named logical vector, where the names give the paths. If the given
object does not exist, `NA` is returned.

## See also

[`file_exists()`](https://fs.r-lib.org/reference/file_access.md),
[`dir_exists()`](https://fs.r-lib.org/reference/file_access.md) and
[`link_exists()`](https://fs.r-lib.org/reference/file_access.md) if you
want to ensure that the path also exists.

## Examples

``` r
dir_create("d")

file_create("d/file.txt")
dir_create("d/dir")
link_create(path(path_abs("d"), "file.txt"), "d/link")

paths <- dir_ls("d")
is_file(paths)
#>      d/dir d/file.txt     d/link 
#>      FALSE       TRUE       TRUE 
is_dir(paths)
#>      d/dir d/file.txt     d/link 
#>       TRUE      FALSE      FALSE 
is_link(paths)
#>      d/dir d/file.txt     d/link 
#>      FALSE      FALSE       TRUE 

# Cleanup
dir_delete("d")
```
