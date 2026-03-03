# Test if a path is an absolute path

Test if a path is an absolute path

## Usage

``` r
is_absolute_path(path)
```

## Arguments

- path:

  A character vector of one or more paths.

## Examples

``` r
is_absolute_path("/foo")
#> [1] TRUE
is_absolute_path("C:\\foo")
#> [1] TRUE
is_absolute_path("\\\\myserver\\foo\\bar")
#> [1] TRUE

is_absolute_path("foo/bar")
#> [1] FALSE
```
