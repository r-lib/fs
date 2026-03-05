# Move or rename files

Compared to [file.rename](https://rdrr.io/r/base/files.html)
`file_move()` always fails if it is unable to move a file, rather than
signaling a Warning and returning an error code.

## Usage

``` r
file_move(path, new_path)
```

## Arguments

- path:

  A character vector of one or more paths.

- new_path:

  New file path. If `new_path` is existing directory, the file will be
  moved into that directory; otherwise it will be moved/renamed to the
  full path.

  Should either be the same length as `path`, or a single directory.

## Value

The new path (invisibly).

## Examples

``` r
file_create("foo")
file_move("foo", "bar")
file_exists(c("foo", "bar"))
#>   foo   bar 
#> FALSE  TRUE 
file_delete("bar")
```
