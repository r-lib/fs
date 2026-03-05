# Construct path to a file or directory

`path()` constructs a relative path, `path_wd()` constructs an absolute
path from the current working directory.

## Usage

``` r
path(..., ext = "")

path_wd(..., ext = "")
```

## Arguments

- ...:

  character vectors, if any values are NA, the result will also be NA.
  The paths follow the recycling rules used in the tibble package,
  namely that only length 1 arguments are recycled.

- ext:

  An optional extension to append to the generated path.

## See also

[`path_home()`](https://fs.r-lib.org/reference/path_expand.md),
[`path_package()`](https://fs.r-lib.org/reference/path_package.md) for
functions to construct paths relative to the home and package
directories respectively.

## Examples

``` r
path("foo", "bar", "baz", ext = "zip")
#> foo/bar/baz.zip

path("foo", letters[1:3], ext = "txt")
#> foo/a.txt foo/b.txt foo/c.txt 
```
