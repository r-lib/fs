# Human readable file sizes

Construct, manipulate and display vectors of file sizes. These are
numeric vectors, so you can compare them numerically, but they can also
be compared to human readable values such as '10MB'.

## Usage

``` r
as_fs_bytes(x)

fs_bytes(x)
```

## Arguments

- x:

  A numeric or character vector. Character representations can use
  shorthand sizes (see examples).

## Examples

``` r
fs_bytes("1")
#> 1
fs_bytes("1K")
#> 1K
fs_bytes("1Kb")
#> 1K
fs_bytes("1Kib")
#> 1K
fs_bytes("1MB")
#> 1M

fs_bytes("1KB") < "1MB"
#> [1] TRUE

sum(fs_bytes(c("1MB", "5MB", "500KB")))
#> 6.49M
```
