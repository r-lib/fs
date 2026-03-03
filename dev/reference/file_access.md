# Query for existence and access permissions

- `file_exists(path)` is a shortcut for `file_access(x, "exists")`

- `dir_exists(path)` and `link_exists(path)` are similar but also check
  that the path is a directory or link, respectively.
  (`file_exists(path)` returns `TRUE` if `path` exists and it is a
  directory. Use
  [`is_file()`](https://fs.r-lib.org/dev/reference/is_file.md) to check
  for file (not directory) existence)

## Usage

``` r
file_access(path, mode = "exists")

file_exists(path)

dir_exists(path)

link_exists(path)
```

## Arguments

- path:

  A character vector of one or more paths.

- mode:

  A character vector containing one or more of 'exists', 'read',
  'write', 'execute'.

## Value

A logical vector, with names corresponding to the input `path`.

## Details

**Cross-compatibility warning:** There is no executable bit on Windows.
Checking a file for mode 'execute' on Windows, e.g.
`file_access(x, "execute")` will always return `TRUE`.

## Examples

``` r
file_access("/")
#>    / 
#> TRUE 
file_access("/", "read")
#>    / 
#> TRUE 
file_access("/", "write")
#>     / 
#> FALSE 

file_exists("WOMBATS")
#> WOMBATS 
#>   FALSE 
```
