# Read the value of a symbolic link

Read the value of a symbolic link

## Usage

``` r
link_path(path)
```

## Arguments

- path:

  A character vector of one or more paths.

## Value

A tidy path to the object the link points to.

## Examples

``` r
file_create("foo")
link_create(path_abs("foo"), "bar")
link_path("bar")
#> /tmp/Rtmp9wRcdf/foo

# Cleanup
file_delete(c("foo", "bar"))
```
